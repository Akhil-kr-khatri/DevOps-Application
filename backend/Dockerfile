# ---------- Build Stage ----------
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# ---------- Final Stage ----------
FROM python:3.11-slim

# Create non-root user
RUN useradd -m djangouser

WORKDIR /app

# Copy installed packages and app
COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

# Switch to non-root user
USER djangouser

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
