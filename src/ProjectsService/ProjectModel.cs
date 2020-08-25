namespace ProjectsService
{
    public class ProjectModel
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public int TasksCount { get; set; }
        public int HoursEstimated { get; set; }
        public int HoursHoursSpent { get; set; }
    }
}