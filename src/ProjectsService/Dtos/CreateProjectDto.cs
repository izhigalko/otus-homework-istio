using System.ComponentModel.DataAnnotations;

namespace ProjectsService
{
    public class CreateProjectDto
    {
        [Required(ErrorMessage="Title can't me empty")]
        public string Title { get; set; }
        public int HoursEstimate { get; set; }
    }    
}