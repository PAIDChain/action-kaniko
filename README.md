# action-kaniko

## How to build

> Note: Please increment the version before build.

> Note: Please login to the AWS ECR before build.

- Build container image.

  ```
  docker build --no-cache --platform=linux/amd64 -t public.ecr.aws/x4v6v7g4/action-kaniko:v1.16.0-debug-cicd.0 .

  docker push public.ecr.aws/x4v6v7g4/action-kaniko:v1.16.0-debug-cicd.0
  ```

- Update the action.yml to apply the container image.

  `image: "docker://public.ecr.aws/x4v6v7g4/action-kaniko:v1.16.0-debug-cicd.0"`
