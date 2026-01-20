"""{{cookiecutter.package_name}} tests."""

import {{cookiecutter.package_name}}


def test_stub() -> None:
    """Stub test to ensure the test suite runs."""
    print({{cookiecutter.package_name}}.__version__)  # noqa: T201


def test__greet() -> None:
    """Test the greet function."""
    assert {{cookiecutter.package_name}}.greet("World") == "Hello, World!"


def test__greet_jim() -> None:
    """Test the greet_jim function."""
    assert {{cookiecutter.package_name}}.greet_jim() == "Hello, Jim!"