# Repository Guidelines

## Project Structure & Module Organization
This Rails 7 app keeps runtime code in `app/`: `app/models`, `app/controllers`, and `app/views` follow the MVC stack, while `app/javascript/controllers` holds Stimulus code referenced via import maps. Shared utilities belong under `lib/`, with rake tasks in `lib/tasks`. Configuration for environments, credentials, and routes lives in `config/`; schema and migrations sit in `db/`. Static assets stay in `public/`, and Minitest suites plus fixtures live under `test/`. Always use the launchers in `bin/` to guarantee the correct Ruby, gems, and env vars.

## Build, Test, and Development Commands
- `bin/setup` installs gems, prepares the database, and seeds starter data.
- `bin/rails server` launches Puma on http://localhost:3000 for local development.
- `bin/rails db:migrate db:seed` applies migrations and seeds deterministic data.
- `bin/rails assets:precompile` builds CSS/JS for production parity checks.
- `bin/rails console` opens a Rails console with application context.

## Coding Style & Naming Conventions
Use Ruby 3.4 with two-space indentation, snake_case for methods/variables, and CamelCase for classes/modules. Name controllers `XyzController`, mailers `XyzMailer`, and jobs `XyzJob`. Prefer single quotes for plain strings, guard clauses over nested conditionals, and extract private helpers when controller actions branch. Import-map modules in `app/javascript` should keep kebab-case filenames (`users-panel_controller.js`) and export Stimulus controllers via `export default class ... extends Controller`.

## Testing Guidelines
The repo uses Minitest (`test/test_helper.rb`) plus Capybara-driven system tests. Co-locate tests beside their layer (`test/models`, `test/controllers`, `test/system`) and name files `*_test.rb`. Use fixtures in `test/fixtures` for deterministic data, covering happy path and edge cases. Every feature needs a unit test and, when UI changes, a system spec (`bin/rails test:system`). Run `bin/rails test` before opening a PR.

## Commit & Pull Request Guidelines
Existing history favors short, imperative subjects (`web app`, `mlcore`). Follow the same tone: <=55-character subject, optional body describing rationale and side effects. Reference GitHub issues in the body (`Refs #123`). Pull requests should explain intent, list setup steps, and include screenshots or console output for UI/API changes. Call out migrations or config flags plus any manual follow-up (e.g., `RAILS_ENV=production bin/rails db:migrate`).

## Security & Configuration Tips
Keep `config/credentials.yml.enc` and `config/master.key` synced securely; never check plaintext secrets into git. Use `ENV.fetch` with defaults for API keys and external endpoints inside initializers. In Docker/CI, pass secrets via environment variables instead of editing tracked files. Clear temporary logs in `log/` before committing, and scrub customer data from fixtures or seeds.
