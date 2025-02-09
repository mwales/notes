# Python tips

# venv

[Back to basics with pip and venv - Bite code!](https://www.bitecode.dev/p/back-to-basics-with-pip-and-venv):
Great article on python venv and how/why to use


Start a python venv by doing the following

```
python3.x -m venv name_of_venv
source name_of_venv/bin/activate
```

Now, activate the python venv before installing pip packages.  Pip packages
will only be available to this venv.

```
python -m pip install thing
``

Run deactivate to quit using the venv

