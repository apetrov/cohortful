# Repository Guidelines

## Project Structure & Module Organization
- `mlcore/worker.py` hosts the Flask API plus RQ enqueue logic; keep queue helpers in this module and extend via clearly named functions (`enqueue_segment`, `validate_payload`).
- `main.py` is the lightweight CLI entry point; use it for ad-hoc scripts or smoke tests that orchestrate the worker.
- `pyproject.toml` and `uv.lock` declare Python 3.14 dependencies; update both via `uv add`/`uv lock` so contributors stay in sync.
- Add datasets, notebooks, or artifacts under dedicated folders (`data/`, `notebooks/`) to keep the repo root lean; functional tests belong in `tests/` mirroring the package layout.

## Build, Test & Development Commands
- `uv sync` installs the locked toolchain and ensures the Redis/Flask stack runs on Python 3.14.
- `uv run python main.py` exercises the CLI and is a quick dependency smoke test.
- `uv run flask --app mlcore.worker run --port 5000` starts the API; pair with a local Redis (`redis-server`) before manual testing.
- `uv run pytest -q` executes the suite; use `-k pattern` while developing focused cases.

## Coding Style & Naming Conventions
- Follow PEP 8 with 4-space indentation, descriptive snake_case for functions, and PascalCase for classes.
- Keep payload contract constants (required keys, queue names) near their usage and document them via module-level comments.
- Prefer type hints on public functions; run `uv run python -m compileall mlcore` if you need a quick syntax check before pushing.

## Testing Guidelines
- Use `pytest` fixtures to stub Redis/RQ; place shared factories inside `tests/conftest.py`.
- Name files `test_<module>.py` and target behavior (e.g., `test_enqueue_errors_when_payload_missing_tag`).
- Aim for coverage on success + failure paths for every endpoint or worker helper; add regression tests when bugs emerge.

## Commit & Pull Request Guidelines
- Recent history shows short, imperative messages (`mlcore`, `web app`); keep following that style, optionally prefixing scope (`worker: validate payload`).
- Reference linked issues in the body, summarize behavior changes, and call out impacts on Redis, queues, or external webhooks.
- PRs should include: what changed, how it was verified (commands above), and any manual steps like seeding Redis data.
