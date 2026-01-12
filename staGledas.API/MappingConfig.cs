using Mapster;
using staGledas.Model.Models;

namespace staGledas.API
{
    public static class MappingConfig
    {
        public static void RegisterMappings()
        {
            TypeAdapterConfig<Service.Database.Korisnici, Korisnici>.NewConfig()
                .Map(dest => dest.Uloge, src => src.KorisniciUloge.Select(ku => ku.Uloga));

            TypeAdapterConfig<Service.Database.Filmovi, Filmovi>.NewConfig()
                .Map(dest => dest.Zanrovi, src => src.FilmoviZanrovi.Select(fz => fz.Zanr));

            TypeAdapterConfig<Service.Database.KlubFilmova, KlubFilmova>.NewConfig()
                .Map(dest => dest.BrojClanova, src => src.Clanovi != null ? src.Clanovi.Count : 0)
                .MaxDepth(3);

            TypeAdapterConfig<Service.Database.KlubFilmovaClanovi, KlubFilmovaClanovi>.NewConfig()
                .Ignore(dest => dest.Klub)
                .MaxDepth(2);

            TypeAdapterConfig<Service.Database.KlubObjave, KlubObjave>.NewConfig()
                .Map(dest => dest.BrojKomentara, src => src.Komentari != null ? src.Komentari.Count : 0)
                .Map(dest => dest.BrojLajkova, src => src.Lajkovi != null ? src.Lajkovi.Count : 0)
                .MaxDepth(3);

            TypeAdapterConfig.GlobalSettings.Default.MaxDepth(3);

            TypeAdapterConfig<Service.Database.Obavijesti, Obavijesti>.NewConfig()
                .Ignore(dest => dest.Primatelj)
                .MaxDepth(2);
        }
    }
}
