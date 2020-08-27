using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ProjectsService
{
    [ApiController]
    [Route("")]
    public class ProjectsController : ControllerBase
    {
        private readonly MainContext _context;

        public ProjectsController(MainContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<ProjectModel>> CreateProject(
            [Required(ErrorMessage="Title can't be empty")] string title,
            int hoursEstimate)
        {
            string lowerTitle = title.ToLowerInvariant();
            if(await _context.Projects.AnyAsync(p => p.Title.ToLowerInvariant() == lowerTitle))
            {
                return BadRequest("Project with this name already exists");
            }

            var model = new ProjectModel
            {
                Id = Guid.NewGuid().ToString(),
                Title = title,
                HoursEstimated = hoursEstimate
            };

            await _context.AddAsync(model);
            await _context.SaveChangesAsync();
            
            return Ok(model);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProjectModel>>> GetAllProjects()
        {
            return Ok(await _context.Projects.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ProjectModel>> GetProject(string id)
        {
            var project = await _context.Projects.FindAsync(id);
            if(project == null)
                return NotFound("Project not found");

            return Ok(project);
        }

        [HttpPost("add-task")]
        public async Task<ActionResult<ProjectModel>> AddTask(
            [Required(ErrorMessage="ProjectId can't be empty")] string projectId,
            [Required(ErrorMessage="TaskId can't be empty")] string taskId)
        {
            bool isSameTaskWasAdded = (await _context.Tasks.FindAsync(taskId)) != null;

            if(isSameTaskWasAdded)
                return Accepted("Task already added");

            var project = await _context.Projects.FindAsync(projectId);
            if(project == null)
                return NotFound("Project not found");

            _context.Tasks.Add(new TaskModel {Id = taskId} );
            project.TasksCount += 1;

            await _context.SaveChangesAsync();

            return Ok(project);
        } 

        [HttpPost("remove-task")]
        public async Task<ActionResult<ProjectModel>> RemoveTask(
            [Required(ErrorMessage="ProjectId can't be empty")] string projectId,
            [Required(ErrorMessage="TaskId can't be empty")] string taskId)
        {
            var task = await _context.Tasks.FindAsync(taskId);
            if(task == null)
                return NotFound("Task not found");                

            var project = await _context.Projects.FindAsync(projectId);

            if(project == null)
                return NotFound("Project not found");

            _context.Tasks.Remove(task);
            project.TasksCount -= 1;

            await _context.SaveChangesAsync();

            return Ok(project);
        }

        [HttpPost("add-hours")]
        public async Task<ActionResult<ProjectModel>> AddHours(
            [Required(ErrorMessage="ProjectId can't be empty")] string projectId,
            [Required(ErrorMessage="Hours can't be empty")] int hours)
        {
            var project = await _context.Projects.FindAsync(projectId);

            if(project == null)
                return NotFound("Project not found");

            project.HoursHoursSpent += hours;

            await _context.SaveChangesAsync();

            return Ok(project);
        }
    }    
}