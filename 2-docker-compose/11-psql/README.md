# PostgreSQL demo

## Backup

```bash
## Docker-compose
docker-compose exec -T psql pg_dump --clean --if-exists -U postgres -d postgres > dump.sql
docker-compose exec -T psql pg_dump --clean --if-exists -U postgres -d postgres | gzip > dump.sql.gz

## Kubernetes
kubectl exec -i postgres-0 -- pg_dump --clean --if-exists -U postgres -d old > old.sql
kubectl exec -i postgres-0 -- pg_dump --clean --if-exists -U postgres -d old | gzip > old.sql.gz
```

## Restore

```bash
## Docker-compose
cat  dump.sql    | docker-compose exec -T psql psql -U postgres -d postgres
zcat dump.sql.gz | docker-compose exec -T psql psql -U postgres -d postgres

## Kubernetes
cat  db-dump.sql    | kubectl exec -i postgres-0 -- psql -U postgres -d postgres
zcat db-dump.sql.gz | kubectl exec -i postgres-0 -- psql -U postgres -d postgres
```

## Analize
```bash
time vacuumdb --dbname=postgres --analyze -U postgres
```

## Tuning

## See also
[Docker Hub Page](https://hub.docker.com/_/postgres/)
