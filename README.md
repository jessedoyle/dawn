# Dawn

Dawn is a tool that allows MacOS development environments to be configured from scratch using a template file (think Ansible).

This gem is very much a proof-of-concept, contains no tests and is very basic. You should use it at your own risk.

## Installation

1. Download the source code as a `.zip` file from GitHub.
2. Unzip the repository archive.
3. `cd unzipped_directory`
4. ```bin/dawn up example.yml --username=`whoami` ```

## Usage

Dawn provides logic for the following actions:

### Shell

This action executes a shell command. All shell actions must provide the following parameters:

- **description** [required] - A high-level description of the action.
- **flag** [required] - A unique identifier for a particular action.
- **type** [required] - Must be `shell`.
- **up** [required] - The raw command that enables the action.
- **down** [required] - The raw command that disables the action.
- **test** [required] - A command used to test if the action is enabled.
- **user** [optional] - The user to execute the command as. Defaults to the current user.

### File

This action creates a file on the local filesystem. All file actions must provide the following parameters:

- **description** [required] - A high-level description of the action.
- **flag** [required] - A unique identifier for a particular action.
- **type** [required] - Must be `file`.
- **content** [required] - The content of the file.
- **path**  [required] - The path to the file on the filesystem.
- **permissions** [optional] - The octal filesystem permissions (as a number) for the file. Defaults to `0400`.

## Parameters

A Dawn template can define a global `parameters` definition. The parameters are resolved when the template is executed via command line arguments.

An example is as follows:

```yaml
parameters:
  - name: username
    description: The system username
    type: string
    short: '-uUSERNAME'
    long: '--username=USERNAME'
    required: true
```

The parameter values can then be interpolated in actions as follows:

```yaml
actions:
  - description: Say Hello
    flag: helloworld
    type: shell
    up: echo up ${parameters:username}
    down: echo down ${parameters:username}
    test: echo test ${parameters:username}
```

## Logging

A logfile of all action executions is kept in `JSON` format in the user's directory in the following location:

```
~/.dawn/log.json
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dawn project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dawn/blob/master/CODE_OF_CONDUCT.md).
