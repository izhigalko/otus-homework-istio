using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TasksService
{
    [ApiController]
    [Route("")]
    public class TasksController : ControllerBase
    {
        private readonly MainContext _context;

#if DEBUG
        private const string _projectsServiceHost = "http://localhost:5000";
#else
        private const string _projectsServiceHost = "http://projects-service.default";
#endif

        public TasksController(MainContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<TaskModel>> GetTask(string id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if(task == null)
                return NotFound("Task not found");

            return Ok(task);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TaskModel>>> GetTasks()
        {
            return Ok(await _context.Tasks.ToListAsync());
        }

        [HttpPost]
        public async Task<ActionResult<TaskModel>> CreateTask(
            [Required(ErrorMessage="Task title must be specified")] string taskTitle,
            [Required(ErrorMessage="Project id must be specified")] string projectId)
        {
            string newTitleLower = taskTitle.ToLowerInvariant();
            bool isAnyTaskSameTitle = await _context.Tasks.AnyAsync(t => t.Title.ToLowerInvariant() == newTitleLower && t.ProjectId == projectId);
            
            if(isAnyTaskSameTitle)
                return BadRequest("Task with same title already exists");

            string taskId = Guid.NewGuid().ToString();

            using(var httpClient = GetHttpClient())
            {
                var request = new HttpRequestMessage();
                request.Method = HttpMethod.Post;
                request.RequestUri = new Uri($"{_projectsServiceHost}/add-task?projectid={projectId}&taskid={taskId}");

                var response = await httpClient.SendAsync(request);

                if(!response.IsSuccessStatusCode)
                {
                    return BadRequest($"Request to projects service failed {response.StatusCode}:\n{response.ReasonPhrase}");
                }
            }            

            var task = new TaskModel
            {
                Id = taskId,
                ProjectId = projectId,
                Title = taskTitle
            };

            await _context.Tasks.AddAsync(task);
            await _context.SaveChangesAsync();

            return Ok(task);            
        }

        [HttpPost("add-hours")]
        public async Task<ActionResult<TaskModel>> AddTaskHours(
            [Required(ErrorMessage="Task id must be specified")] string taskId,
            [Required(ErrorMessage="Hours must be specified")] int hours)
        {
            var task = await _context.Tasks.FindAsync(taskId);
            if(task == null)
                return NotFound("Task not found");

            if((task.HoursSpent + hours) < 0)
                return BadRequest($"Task hours can't become less than 0. Now tak has only {task.HoursSpent} hours");

            if(task.ProjectId != null)
            {
                using(var httpClient = GetHttpClient())
                {
                    var request = new HttpRequestMessage();
                    request.Method = HttpMethod.Post;
                    request.RequestUri = new Uri($"{_projectsServiceHost}/add-hours?projectid={task.ProjectId}&hours={hours}");

                    var response = await httpClient.SendAsync(request);

                    if(!response.IsSuccessStatusCode)
                    {
                        return BadRequest($"Request to projects service failed {response.StatusCode}:\n{response.ReasonPhrase}");
                    }
                }
            }                   

            task.HoursSpent += hours;

            await _context.SaveChangesAsync();

            return Ok(task);
        }

        private HttpClient GetHttpClient()
        {
            var handler = new HttpClientHandler()
            { 
                ServerCertificateCustomValidationCallback 
                    = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
            };

            return new HttpClient(handler);
        }
        
    }    
}