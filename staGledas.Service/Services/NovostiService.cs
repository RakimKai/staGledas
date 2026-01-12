using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class NovostiService : BaseCRUDService<Model.Models.Novosti, NovostiSearchObject, Database.Novosti, NovostiUpsertRequest, NovostiUpsertRequest>, INovostiService
    {
        public NovostiService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.Novosti> AddFilter(NovostiSearchObject searchObject, IQueryable<Database.Novosti> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NaslovGTE))
            {
                filteredQuery = filteredQuery.Where(x => x.Naslov != null && x.Naslov.ToLower().Contains(searchObject.NaslovGTE.ToLower()));
            }

            if (searchObject?.AutorId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.AutorId == searchObject.AutorId);
            }

            if (searchObject?.IsAutorIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Autor);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.OrderBy))
            {
                var items = searchObject.OrderBy.Split(' ');
                if (items.Length == 1)
                {
                    filteredQuery = filteredQuery.OrderBy("@0", searchObject.OrderBy);
                }
                else
                {
                    filteredQuery = filteredQuery.OrderBy(string.Format("{0} {1}", items[0], items[1]));
                }
            }
            else
            {
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumKreiranja);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(NovostiUpsertRequest request, Database.Novosti entity)
        {
            entity.DatumKreiranja = DateTime.Now;
            entity.BrojPregleda = 0;
        }

        public override void BeforeUpdate(NovostiUpsertRequest request, Database.Novosti entity)
        {
            entity.DatumIzmjene = DateTime.Now;
        }

        public override Model.Models.Novosti GetById(int id)
        {
            var entity = Context.Novosti.Include(x => x.Autor).FirstOrDefault(x => x.Id == id);
            if (entity != null)
            {
                entity.BrojPregleda = (entity.BrojPregleda ?? 0) + 1;
                Context.SaveChanges();
            }
            return Mapper.Map<Model.Models.Novosti>(entity);
        }
    }
}
