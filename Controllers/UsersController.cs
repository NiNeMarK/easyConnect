using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace easyConnect.Controllers
{
    [Route("api/[controller]")] // บรรทัดนี้จะทำให้ URL เป็น /api/users
    [ApiController]            // บรรทัดนี้บอกว่านี่คือ Web API (ไม่ใช่หน้าเว็บ MVC)
    public class UsersController : Controller
    {
        private readonly AppDbContext _context;

        public UsersController(AppDbContext context)
        {
            _context = context;
        }
        // ใช้ Static List แทน Database ชั่วคราวเพื่อให้รันได้ทันที
        private static List<UserDto> _users = new List<UserDto>();

        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            // ดึงข้อมูลจากฐานข้อมูล Supabase จริงๆ
            var users = await _context.Users.ToListAsync();
            return Ok(users);
        }

        [HttpPost]
        public async Task<IActionResult> AddUser(UserEntity user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync(); // บันทึกลง Supabase
            return Ok(user);
        }
    }
}


public class UserDto
{
    public int Id { get; set; }
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public string Address { get; set; } = "";
    public string BirthDate { get; set; } = "";
    public int Age { get; set; }
}
