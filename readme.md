# Primate's calls feature extraction, dimension reduction and separation score


## Software Requirements 

To run the pipeline you will need a distribution of python (2.7) and the
modules to extract features and compute ABX scores; The simplest way to get all
the requirements is to install using conda.

Follow the instructions from [anacondawebpage](https://www.anaconda.com/download/) 
to install a suitable distribution for your, the supported architectures for the 
modules dealing with primate data are Linux and OSX. Once conda is installed in 
your system, you can follow these commands:

```bash
conda create --name monkeys
source activate monkeys
conda install -c primatelang mcr
conda install -c primatelang easy_abx
```

Conda command will install the required extra packages to run `mcr` and `easy_abx`.

The `mcr` contains a module and related scripts that does feature extraction,
automatic call recognition, call transcription and feature dimension reduction
(DR). In this pipeline only the feature extraction and DR are used. In `mcr`
the feature extraction is done thought spectral features and the output are
feature frames in one of the available options (Mel, filter-banks, ...). All
options are set in a configuration file, as example see
`config/SPECTRAL_STACK50_NFILT40_6ca96b.cfg` and
`config/SPECTRAL_STACKFREE_NFILT40_c74e01.cfg`, the first is the configuration
of a fix size stack (50 frames) and the second is for a free size number of
frames.

In `mcr` DR is done on the output of the feature extraction scripts; the
available options for doing DR on variable length features are: 'LSTM',
'TRIPLETLOSS', 'LSTMEMBED' and 'AE', for fix length features the option are
'PCA', 'LDA', 'TSNE' and 'LSA'. The output of the DR is a csv file that
corresponds to the shrinked features, one for each sample in the input 
 
`easy_abx` is a package that does ABX discrimination, essentially this
discrimination task is used to determine if two categories are the same or
different, an that is done comparing three samples: the first two samples (A
and B) are different, and the third sample (X) matches the first one (A), by
doing this over all possible triplets in the data population it is possible to
judge which categories resemble.   


## How to use

check the example on `bin/` 

## Annotation files

The feature extraction scripts require an annotation file; the annotation is a
csv file that has four columns, the first contains the name and complete path
of the acoustic file, the second and thirty are the beginning and ending
timestamps pointing to segments in the audio file, and the last column contain
the label for the call. 

As an example, suppose we have two one-second audio recordings,
`/home/me/A.wav` and `/home/me/B.wav` and we have annotated a ***PY*** call in
file ***A*** at the time interval 0.100 - 0.200 and a ***H*** call in file
***B*** at the time interval 0.500 - 0.600; we then make an annotation file
(annotation.csv) with the following contents to the feature extraction script:

```csv
filename,start,end,label
/home/me/A.wav,0.100,0.200,PYOW
/home/me/B.wav,0.500,0.600,HACK
```

## Configuration files


## Notebooks



## Pipeline description

### data selection

3136 calls 


     40 1
     75 2
     38 3
     34 4
    147 A
     27 A*
     98 A_titi
    526 B
     30 BO
     19 BS
      7 Bw
     11 C
    145 h
     17 H
     37 K
    131 K+
     50 KA
    370 KATR
     38 Nscrm
    127 p
    211 PY
    739 r
    141 s
     43 W
     33 W+
      2 x



blue monkeys were homogenized


### feature extraction

Before doing acoustic feature extraction, we selected all annotations from 
praat files, a quality control over these labels was done by listening and
looking at spectrograms simultaneusly, from this QC all non-primate calls
labels were removed: silence and noise annotations, and also corrections 
in the timestamps for a selection of Murphy et al (2013) Blue Monkeys Hack calls, 
to make them comparable to Fuller et al (2014). Sound records were collected 
from multiple sources, these records are in different sound formats, 
sample rates and number of channels, to homogenize the processing
pipeline all files were converted to a commun format (wav, 16bit), and sampled 
at 16000Hz in monophonic channel.

We follow the steps developed by Versteegh et all (2016) for feature extraction, 
and it consist in gattering features from audio records for the selected 
annotations, to all these traces the DC component was removed by using a notch
high pass filter, after that a spectrogram was computed using short-time
Fourier transforms on overlapping windows of 25ms shifted by 10ms, each
frame of 25ms samples 1024 frequency components in the DFT space, and 
then transforming the frequency components through a set of 40 filters stacks evenly
spaced on the Mel scale from 133.33 to 6855.50Hz. In this pipeline we use
two different stack size, an static 50 frames stack that begins on the first
onset of the call, and a variable stack size with all frames from the begining 
to the ending of the call.




### feature reduction

To discover non-linear relations between different monkey species calls and to
remove noise and non undesirable information we look for compact representation
of the acoustic monkey calls. We extracted features for two different configurations,
the fist one are fix length features with size of 40 filter-banks by 50 frames (1.25s), that
flattened gives us call representations of 2000 elements, the second are 
variable size features with a width of 40 filter-banks and a non-regular length.

For fix lenght feature representation we use standard dimension reduction 
to shrink from 2000 elements to 20 by using the algorithms in scikit-learn 
(Pedregosa et al, 2011). From this toolbox we use the Principal Component
Analysis (PCA), Linear Discriminatn Analysis (LDA), Latent Semantic Analysis (LSA),
and t-distributed Stochastic Neighbor Embedding (t-SNE); from these methods PCA, LDA 
and LSA performs linear dimesionality reduction by means of singular value decomposition
(SVD) and we run them using the default parameters from scikit-learn packages. T-SNE is a 
non-linear DR method used in visualization that converts similarities between data points 
to joint probabilities and tries to minimize the Kullback-leibler divergence between the
join probabilities of the low-dimensional embedding and the high-dimensional
data (van der Maaten and Hinton, 2008), for this DR algorith we used the default 
parameters of the package with the exact search option. 

As classical methods requires fix lenght 
lstm auto-encoder 

auto-encoder some propeties are noise reduction,  

The idea of autoencoders has been part of the historical landscape of
neuralnetworks for decades (LeCun, 1987; Bourlard and Kamp, 1988; Hinton and
Zemel,1994). Traditionally, autoencoders were used for dimensionality reduction
or feature learning.



Principal component analysis (PCA) is used in diverse settings for
dimensionality reduction. If data elements are all the same size, there are
many approaches to estimating the PCA decomposition of the dataset. However,
many datasets contain elements of different sizes that must be coerced into a
fixed size before analysis. Such approaches introduce errors into the resulting
PCA decomposition. We introduce CO-MPCA, a nonlinear method of directly
estimating the PCA decomposition from datasets with elements of different
sizes. We compare our method with two baseline approaches on three datasets: a
synthetic vector dataset, a synthetic image dataset, and a real dataset of
color histograms extracted from surveillance video. We provide quantitative and
qualitative evidence that using CO-MPCA gives a more accurate estimate of the
PCA basis.

### abx 

The workflow used on processing the acoustic data is data extraction, feature reduction
and evaluation of call representations by using ABX



[1] Schatz T., V. Peddinti, F. Bach, A. Jansen, H. Hynek, E. Dupoux. Evaluating
speech features with the Minimal-Pair ABX task: Analysis of the classical
MFC/PLP pipeline. Proceedings of INTERSPEECH, 2013.

[2] Zhai M., F. Shi, D Duncan and N. Jacobs. Covariance-Based PCA for
Multi-size Data. 22nd International Conference on Pattern Recognition, 2014

Thomas Schatz. ABX-Discriminability Measures and Applications. Cognitive
science. Université Paris 6 (UPMC), 2016. English.

Versteegh M., J. Kuhn, G. Synnaeve, L. Ravaux, E. Chemla, C. Cäsar,
J. Fuller, D. Murphy, A. Schel, and E. Dunbar. Classification and automatic
transcription of primate calls, J. Acoust. Soc. Am., v140, 2016

Fuller J. L., The vocal repertoire of adult male blue monkeys (Cercopithecus
mitis stulmanni): a quantitative analysis of acoustic structure. Am J Primatol. 76(3), 2014

Murphy D., S. Lea, K. Zuberbühler. Male blue monkey alarm calls encode
predator type and distance, Animal Behav., 85(1), 2013

Pedregosa, F. G. Varoquaux, A. Gramfort, V. Michel, B. Thirion, O. Grisel, M. Blondel, P. Prettenhofer, R. Weiss, V. Dubourg, J. Vanderplas, A. Passos, D. Cournapeau, M. Brucher, M. Perrot, E. Duchesnay, Scikit-learn: Machine Learning in Python, J. Mach. Learn. Res, vol 12, 2011 


Chollet F and other, Keras, https://keras.io, 2015

van der Maaten, L.J.P. and G.E. Hinton. Visualizing High-Dimensional Data
Using t-SNE. J. Mach. Learn. Res. vol 9, 2008.

