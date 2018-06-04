
Content Description 
===================


- jupyter/: various python experiments in jupyter notebooks

- config/: it contains the configuration files use by [[mcr][https://github.com/primatelang/mcr]]
          scripts, the name of the configuration file describe the experiment, for example
           
    - 'SPECTRAL_STACK50_NFILT40_6ca96b.cfg' corresponds to the configuration file for 
      the experiment using spectral features with a stack of 50 frames and 40 mel-filterbanks; 
      '6ca96b' is an unique identification to the stage of the configuration file and 
      it's created using the `md5sum` command on the cfg file.

- corpus/: directory with the raw waveforms and transcription files.

- outputs/: has all result for the corpus we are working. The outputs are csv files,
            and I included two sets of files :

    - *_input.csv: the input for the ABX scores, the name of the file describes the experiment,
      and it is the same that the configuration file (e.g. 'SPECTRAL_STACK50_NFILT40_6ca96b'), 
      the name of the file also includes extra information of the processing pipeline, for example 
      if the features corresponds to a RAW data, PCA or LDA transformations. The files are csv
      with comma delimiters, each row in the file corresponds to a call, in the first 
      column is keep the label of the call, and the rest of the columns are its features.

    - *_results.csv: are the ABX scores for the previous input.

