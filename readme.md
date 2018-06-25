# Primate's calls feature extraction, dimension reduction and separation score


## Software Requirements 

To run the pipeline you will need a distribution of python (2.7) and the 
modules to extract features and compute ABX scores; The simplest 
way to get all the requirements is to install using conda.

Follow the instructions from [anaconda webpage](https://www.anaconda.com/download/)
to install a suitable distribution for your, the supported architectures for the 
modules dealing with primate data are Linux and OSX. Once conda is installed in your
system, you can follow these commands:

```bash
conda create --name monkeys
source activate monkeys
conda install -c primatelang mcr
conda install -c primatelang easy_abx
```

Conda command will install the required extra packages to run `mcr` and `easy_abx`.

The `mcr` contains a module and related scripts that does feature extraction, automatic call 
recognition, call transcription and feature dimension reduction (DR). In this pipeline only the
feature extraction and DR are used. In `mcr` the feature extraction is done
thought spectral features and the output are feature frames in one of the available
options (Mel, filter-banks, ...). All options are set in a configuration file, as example
see `config/SPECTRAL_STACK50_NFILT40_6ca96b.cfg` and 
`config/SPECTRAL_STACKFREE_NFILT40_c74e01.cfg`, the first is the configuration of 
a fix size stack (50 frames) and the second is for a free size number of frames.

In `mcr` DR is done on the output of the feature extraction scripts; 
the available options for doing DR on variable length features are: 'LSTM',
'TRIPLETLOSS', 'LSTMEMBED' and 'AE', for fix length features the option are 
'PCA', 'LDA', 'TSNE' and 'LSA'. The output of the DR is a csv file that corresponds
to the shrinked features, one for each sample in the input  

`easy_abx` is a package that does ABX discrimination, essentially this discrimination task is
used to determine if two categories are the same or different, an that is done comparing 
three samples: the first two samples (A and B) are different, and the third 
sample (X) matches the first one (A), by doing this over all possible triplets in the 
data population it is possible to judge which categories resemble.   


## How to use


###  Annotation files

The feature extraction scripts require an annotation file; the annotation is a csv file that 
has four columns, the first contains the name and complete path of the acoustic file, the second
and thirty are the beginning and ending timestamps pointing to segments in the audio file, and
the last column contain the label for the call. 

As an example, suppose we have two one-second audio recordings, `/home/me/A.wav` and 
`/home/me/B.wav` and we have annotated a ***PY*** call in file ***A*** at the time 
interval 0.100 - 0.200 and a ***H*** call in file ***B*** at the time interval 
0.500 - 0.600; we then make an annotation file (annotation.csv) with the 
following contents to the feature extraction script:

```csv
filename,start,end,label
/home/me/A.wav,0.100,0.200,PYOW
/home/me/B.wav,0.500,0.600,HACK
```

## Pipeline description

The workflow used on processing the acoustic data is data extraction, feature reduction
and evaluation of call representations by using ABX


Timestamps and annotations of primates set by 


[1] T. Schatz, V. Peddinti, F. Bach, A. Jansen, H. Hynek, E. Dupoux. Evaluating speech features with the Minimal-Pair ABX task: Analysis of the classical MFC/PLP pipeline. Proceedings of INTERSPEECH, 2013.



