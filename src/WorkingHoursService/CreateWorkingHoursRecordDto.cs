using System.ComponentModel.DataAnnotations;

namespace WorkingHoursService
{
    public class CreateWorkingHoursRecordDto
    {
        [Required(ErrorMessage="Task id must be specified")]
        public string TaskId {get; set; }
        [Required(ErrorMessage="Description must be specified")]
        public string Description { get; set; }
        [Required(ErrorMessage="Hours must be specified")]
        public int Hours { get; set; }
    }
}