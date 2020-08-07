import setuptools

with open("pip_README.md", "r") as fh:

    long_description = fh.read()
setuptools.setup(

     name='dockerstats',

     version='0.1.4',

     scripts=['dockerstats'] ,

     author="Lukas Kienast",

     description="A package to sum memory usage on containers",

     long_description=long_description,

     long_description_content_type="text/markdown",

     packages=setuptools.find_packages(),

     classifiers=[

         "Programming Language :: Python :: 3",

         "License :: OSI Approved :: MIT License",

         "Operating System :: OS Independent",

     ],

 )
