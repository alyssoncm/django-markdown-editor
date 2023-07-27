FROM alpine:3.16.0

WORKDIR /app

# Installing Python and pip using the apk package manager
RUN apk add --no-cache python3 py3-pip tini; \

# Installing dependencies using pip and upgrading pip and setuptools-scm
    pip install --upgrade pip setuptools-scm; \

# Copying the application code to the container
    COPY . .

# Building and installing the application along with running required migrations
    RUN python3 setup.py install; \
    python3 martor_demo/manageem.py makigrations; \
    python3 martor_demo/manage.py migrate; \

# Creating a group and user
    addgroup -g 1000 appuser; \
    adduser -u 1000 -G appuser -D -h /app appuser; \

# Changing ownership of the app directory to the created user
    chown -R appuser:appuser /app

# Changing the user to the created user
USER appuser

# Entrypoint command for initializing the container with tini
ENTRYPOINT [ "tini", "--" ]

# CMD command to run the Django development server on 0.0.0.0:8000
CMD [ "python3", "/app/martor_demo/manage.py", "runserver", "0.0.0.0:8000" ]
