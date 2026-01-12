# **staGledas**
Seminarski rad za predmet Razvoj Softvera II

# Upute za pokretanje:
1. Pokrenuti komandu: ```docker-compose up --build``` u terminalu.
2. Pustiti da se izvrti docker compose koji će da nam builda, seeda bazu i pokrene API.
3. API će biti dostupan na ```http://localhost:5284/swagger/index.html```

## Pokretanje Mobile aplikacije:
1. Pokrenuti Android emulator (Android Studio -> Device Manager).
2. U terminalu navigirati do ```staGledas/stagledas_mobile```
3. Pokrenuti komandu: ```flutter run --dart-define=baseUrl=http://10.0.2.2:5284/api/```
4. Koristiti aplikaciju.

## Pokretanje Admin aplikacije:
1. U terminalu navigirati do ```staGledas/stagledas_admin```
2. Pokrenuti komandu: ```flutter run -d chrome``` ili ```flutter run -d windows```
3. Koristiti aplikaciju.

## Kredencijali:
**Admin Korisnik**\
  Korisničko ime: ```admin```\
  Lozinka: ```string```
**Standard Korisnik**\
  Korisničko ime: ```string```\
  Lozinka: ```test123```

## Stripe
U sklopu seminarskog rada za plaćanje premium pretplate korišten je Stripe. Da bi testirali plaćanje on nam osigurava testne podatke za unos kreditne kartice. Oni su sljedeći:

Broj kartice: ```4242 4242 4242 4242```\
CVC: ```Bilo koje 3 cifre```\
Datum isteka: ```Bilo koji u budućnosti```
ZIP Code: ```Bilo koji``` \

Plaćanje je omogućeno kada se uđe u Profil ekran i klikne na "Premium" opciju.

## Putanja do mjesta u aplikaciji gdje se koristi RECOMMENDER sistem:
1. Ulogovati se na mobilnu aplikaciju kredencijalima: username: "test" i password "string".
2. Navigirati se do Search (Pretraži) ekrana putem bottom navigacije.
3. Na ekranu će se prikazati sekcija "Preporučeno za tebe:" sa personalizovanim preporukama filmova.

### Kako funkcioniše recommender sistem:
Preporuke se generišu na osnovu korisnikovih interakcija koristeći Microsoft.ML Matrix Factorization algoritam.

**Izvori podataka za preporuke (po prioritetu):**
1. **Recenzije** - Filmovi koje je korisnik ocijenio sa 4+ zvjezdice
2. **Lajkovani filmovi** - Filmovi koje je korisnik lajkovao tokom onboarding procesa (swipe desno)
3. **Watchlist** - Filmovi koje je korisnik označio kao pogledane

**Onboarding proces:**
- Prilikom prve registracije, korisnik prolazi kroz onboarding gdje swipe-a filmove (desno = sviđa mi se, lijevo = ne sviđa mi se)
- Filmovi swipe-ani udesno se spremaju u bazu i koriste za generisanje personalizovanih preporuka
- Onboarding koristi 100 trenutno najpopularnijih filmova sa TMDb API-ja

**Fallback mehanizam:**
- Ako korisnik nema nikakvih interakcija, prikazuju se trending filmovi
- Ako korisnik ima interakcije ali nema visoko ocijenjenih filmova, prikazuju se popularni filmovi

## RabbitMQ
RabbitMQ korišten za:
- Slanje e-maila korisniku kada aktivira premium pretplatu
- Slanje welcome e-maila novim korisnicima

## E-mail
E-mail adresa korištena za slanje mejlova jeste:\
```stagledas28@gmail.com```

## SignalR
SignalR korišten za real-time chat funkcionalnost između korisnika koji se međusobno prate (mutual followers).

## TMDb API
Aplikacija koristi TMDb (The Movie Database) API za:
- Pretragu filmova
- Dohvatanje detalja o filmovima
- Preporuke sličnih filmova
- Trending i popularni filmovi
