import os
from setuptools import setup
from setuptools.dist import Distribution

class BinaryDistribution(Distribution):
    def has_ext_modules(self):
        return True

assert os.path.exists("ADBASFOR/lib/BASFOR_conif.so"), "compile the shared library first"

setup(
    name="ADBASFOR",
    version="0.1",
    packages=["ADBASFOR", "ADBASFOR.lib"],
    package_data={"ADBASFOR.lib": ["BASFOR_conif.so"]},
    include_package_data=True,
    distclass=BinaryDistribution
)
