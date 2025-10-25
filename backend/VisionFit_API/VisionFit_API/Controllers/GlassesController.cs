using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VisionFit_API.Data;
using VisionFit_API.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using VisionFit_API.Data.VisionFit_API.Data;
using Microsoft.AspNetCore.Authorization;

namespace VisionFit_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class GlassesController : ControllerBase
    {
        private readonly VisionFitDbContext _context;

        public GlassesController(VisionFitDbContext context)
        {
            _context = context;
        }

        // GET: api/glasses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Glasses>>> GetGlasses()
        {
            return await _context.Glasses.ToListAsync();
        }

        // GET: api/glasses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Glasses>> GetGlasses(int id)
        {
            var glasses = await _context.Glasses.FindAsync(id);
            if (glasses == null)
                return NotFound();
            return glasses;
        }

        //GET: api/glasses/round
        [HttpGet("by-face-shape/{faceShape}")]
        public async Task<IActionResult> GetGlassesByFaceShape(string faceShape)
        {
            var filteredGlasses = await _context.Glasses
                .Where(g => g.FaceShape.Replace(" ", "").ToLower().Contains(faceShape.Replace(" ", "").ToLower()))
                .ToListAsync();

            if (filteredGlasses == null || !filteredGlasses.Any())
                return NotFound("Bu yüz şekli için gözlük bulunamadı.");

            return Ok(filteredGlasses);
        }


        // POST: api/glasses
        [HttpPost]
        public async Task<ActionResult<Glasses>> PostGlasses(Glasses glasses)
        {
            _context.Glasses.Add(glasses);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetGlasses), new { id = glasses.Id }, glasses);
        }

        // PUT: api/glasses/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutGlasses(int id, Glasses glasses)
        {
            if (id != glasses.Id)
                return BadRequest();

            _context.Entry(glasses).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/glasses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteGlasses(int id)
        {
            var glasses = await _context.Glasses.FindAsync(id);
            if (glasses == null)
                return NotFound();

            _context.Glasses.Remove(glasses);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/glasses/brands
        [HttpGet("brands")]
        public async Task<IActionResult> GetDistinctBrands()
        {
            try
            {
                var brandsRaw = await _context.Glasses
                    .Where(g => !string.IsNullOrEmpty(g.Brand) && !string.IsNullOrEmpty(g.BrandImageUrl))
                    .ToListAsync();

                var distinct = brandsRaw
                    .GroupBy(g => new { g.Brand, g.BrandImageUrl })
                    .Select(g => new
                    {
                        Brand = g.Key.Brand,
                        BrandImageUrl = g.Key.BrandImageUrl
                    })
                    .ToList();

                return Ok(distinct);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }


    }
}
