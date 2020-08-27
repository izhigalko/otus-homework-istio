namespace TasksService
{
    public class TaskModel
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public string ProjectId { get; set; }
        public int HoursSpent { get; set; }
    }
}