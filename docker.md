### Forward 1p to docker container
`-v $(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK`

### Temp `$HOME`
`TMPHOME=$(mktemp -d); HOME=$TMPHOME docker run ...`
