# Phx
- Used to be www.postya.net
- Now hosted on https://read.jmnorlund.net

## To build and deploy
Change the version in `mix.exs`.
- `make build`

## To deploy to production
- `make deploy`

## To get a remote console on the production system
SSH to it and run:
`~/apps/phx/releases/<releasen number>/phx.sh remote_console`

### For verbosity
Use `-V` flag.

## To see logs,
`tail -f apps/phx/var/log/erlang.log.1`
or, if started by systemd, see `/var/log/syslog`

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
