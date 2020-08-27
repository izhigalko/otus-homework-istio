using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace WorkingHoursService
{
    [ApiController]
    [Route("")]
    public class WorkingHoursController : ControllerBase
    {
#if DEBUG
        private const string _tasksServiceHost = "http://localhost:5002";
#else
        private const string _tasksServiceHost = "http://tasks-service.default";
#endif

        private readonly MainContext _context;

        public WorkingHoursController(MainContext context)
        {
            _context = context;
        }   

        [HttpGet]
        public async Task<ActionResult<IEnumerable<WorkingHoursRecord>>> GetWorkingHoursRecords()
        {
            return Ok(await _context.WorkingHoursRecords.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<WorkingHoursRecord>> GetWorkingHoursRecord(string id)
        {
            var record = await _context.WorkingHoursRecords.FindAsync(id);
            if(record == null)
                return NotFound("Record not found");

            return Ok(record);
        }

        [HttpPost]
        public async Task<ActionResult<WorkingHoursRecord>> CreateWorkingHoursRecord([FromBody] CreateWorkingHoursRecordDto dto)
        {
            using(var httpClient = GetHttpClient())
            {
                var request = new HttpRequestMessage();
                request.Method = HttpMethod.Post;
                request.RequestUri = new Uri($"{_tasksServiceHost}/add-hours?taskid={dto.TaskId}&hours={dto.Hours}");

                var response = await httpClient.SendAsync(request);

                if(!response.IsSuccessStatusCode)
                {
                    return BadRequest($"Request to tasks service failed {response.StatusCode}:\n{response.ReasonPhrase}");
                }
            }

            var record = new WorkingHoursRecord
            {
                Id = Guid.NewGuid().ToString(),
                Hours = dto.Hours,
                Description = dto.Description,
                TaskId = dto.TaskId
            };

            await _context.AddAsync(record);
            await _context.SaveChangesAsync();

            return Ok(record);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteRecord(string id)
        {
            var record = await _context.WorkingHoursRecords.FindAsync(id);
            if(record == null)
                return NotFound("Working hours record not found");
            
            if(!string.IsNullOrWhiteSpace(record.TaskId))
            {
                using(var httpClient = GetHttpClient())
                {
                    var request = new HttpRequestMessage();
                    request.Method = HttpMethod.Post;
                    request.RequestUri = new Uri($"{_tasksServiceHost}/add-hours?taskid={record.TaskId}&hours={-record.Hours}");

                    var response = await httpClient.SendAsync(request);

                    if(!response.IsSuccessStatusCode)
                    {
                        return BadRequest($"Request to tasks service failed {response.StatusCode}:\n{response.ReasonPhrase}");
                    }
                }
            }

            _context.Remove(record);
            await _context.SaveChangesAsync();

            return Ok();
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