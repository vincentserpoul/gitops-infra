## init the cluster

```bash
    make init
```

it will:
- create the db pasword
- create the age encrypt key for the designated env
- install the necessary CRDs

## create a local root cert

```bash
    cd env/overlays/dev
    make init
    cd ../../..
```

## install all runtime resources

```bash
    make apply-all
```
