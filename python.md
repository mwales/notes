# Python tips

## venv

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
```

Run deactivate to quit using the venv

## Offline pip

Often want to use a python pip package on an offline computer.  If the Ubuntu/Debian repos don't have
the python package in a dpkg, you are usually stuck with trying to get from pip.  General idea here
is to download wheel files that you can copy from online system to an offline system, and then install
the packages from the wheel files.

This method is real picky about the python version.  So make sure you are on identical versions of your
distro else you'll get wheel files fron the incorrect python version.

### Downloading

Setup a venv for you mirror purposes, and install the packages you want mirrored.

```
pip freeze > requirements.txt
mkdir wheelhouse
pip download -r requirements.txt -d wheelhouse
```

Tar your requirements and wheelhouse directory up, and transfer to your offline computer.

### Installing (offline computer)

Setup your venv on your offline computer.  Install the packages from wheels by executing the following.

```
pip install -r requirements.txt --no-index --find-links wheelhouse
```
