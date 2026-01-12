using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class FilmoviService : BaseCRUDService<Model.Models.Filmovi, FilmoviSearchObject, Database.Filmovi, FilmoviInsertRequest, FilmoviUpdateRequest>, IFilmoviService
    {
        public FilmoviService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.Filmovi> AddFilter(FilmoviSearchObject searchObject, IQueryable<Database.Filmovi> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.Naslov))
            {
                filteredQuery = filteredQuery.Where(x => x.Naslov != null && x.Naslov.Contains(searchObject.Naslov));
            }

            if (searchObject?.GodinaOd.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.GodinaIzdanja >= searchObject.GodinaOd);
            }

            if (searchObject?.GodinaDo.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.GodinaIzdanja <= searchObject.GodinaDo);
            }

            if (searchObject?.ZanrId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.FilmoviZanrovi.Any(fz => fz.ZanrId == searchObject.ZanrId));
            }

            if (searchObject?.MinOcjena.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.ProsjecnaOcjena >= searchObject.MinOcjena);
            }

            if (searchObject?.IsZanroviIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.FilmoviZanrovi).ThenInclude(x => x.Zanr);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.OrderBy))
            {
                var items = searchObject.OrderBy.Split(' ');
                if (items.Length > 2 || items.Length == 0)
                {
                    throw new ApplicationException("You can only sort by up to two fields.");
                }
                if (items.Length == 1)
                {
                    filteredQuery = filteredQuery.OrderBy("@0", searchObject.OrderBy);
                }
                else
                {
                    filteredQuery = filteredQuery.OrderBy(string.Format("{0} {1}", items[0], items[1]));
                }
            }

            return filteredQuery;
        }

        public override void AfterInsert(Database.Filmovi entity, FilmoviInsertRequest request)
        {
            if (request.ZanroviIds != null && request.ZanroviIds.Count > 0)
            {
                foreach (var zanrId in request.ZanroviIds)
                {
                    Context.FilmoviZanrovi.Add(new FilmoviZanrovi
                    {
                        FilmId = entity.Id,
                        ZanrId = zanrId
                    });
                }
            }

            Context.SaveChanges();
        }

        public override void BeforeUpdate(FilmoviUpdateRequest request, Database.Filmovi entity)
        {
            if (request.ZanroviIds != null)
            {
                var existingZanrovi = Context.FilmoviZanrovi.Where(x => x.FilmId == entity.Id).ToList();
                Context.FilmoviZanrovi.RemoveRange(existingZanrovi);

                foreach (var zanrId in request.ZanroviIds)
                {
                    Context.FilmoviZanrovi.Add(new FilmoviZanrovi
                    {
                        FilmId = entity.Id,
                        ZanrId = zanrId
                    });
                }
            }

        }
    }
}
