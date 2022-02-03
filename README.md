![Preview](docs/Midarr-light.png)

<div align="center">
    <a href="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml"><img src="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml/badge.svg" alt="Build Status"></a>
</div>

The next-generation media server has arrived, `Midarr` aims to provide an experience like none other:

* Beautifully crafted interface enhances your media viewing experience
* Social from the get go - user online and watch statuses
* Integrations with Radarr and Sonarr
* and plenty more to come...

## Usage

Docker compose example:

```yaml
version: '3'

volumes:
  database-data:

services:
  midarr:
    image: ghcr.io/midarrlabs/midarr-server:latest
    depends_on:
      database:
        condition: service_healthy
    ports:
      - "4000:4000"
    volumes:
      - /path/to/radarr/movies:/movies
      - /path/to/sonarr/shows:/shows
    restart: unless-stopped

  database:
    image: bitnami/postgresql:14
    healthcheck:
      test: "exit 0"
    volumes:
      - database-data:/bitnami/postgresql
    ports:
      - 5432:5432
    environment:
      - POSTGRESQL_USERNAME=my_user
      - POSTGRESQL_PASSWORD=password123
      - POSTGRESQL_DATABASE=my_database
```

## Configuration

Integrations must also provide the volumes as mounted in your Radarr and Sonarr instances:
```bash
/path/to/radarr/movies:/movies
/path/to/sonarr/shows:/shows
```
This is so `Midarr` has the same reference to your media library as the integrations, and can find them.

## Contributing

Thank you for your contributions! Big or small - we welcome all!

## License

`Midarr` is open-sourced software licensed under the [MIT license](LICENSE).