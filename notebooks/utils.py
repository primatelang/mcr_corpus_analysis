from itertools import product, combinations, permutations 
from collections import defaultdict 
import time 

import numpy as np 
import pandas as pd 
from sklearn.decomposition import PCA 

import seaborn as sns 
import matplotlib.pyplot as plt 

def read_csv(data_file):
    """ read a csv separated by ',', asumming that first column are the calls/labels and the
    rest are the features 
    """
    labels_from_csv = []
    features_from_csv = []
    with open(data_file, 'r') as dfile:
        for line in dfile.readlines():
            row = line.strip().split(',')
            labels_from_csv.append(row[0])  
            features_from_csv.append([float(x) for x in row[1:]])
    return features_from_csv, labels_from_csv


def features_to_pandas_2D(features, labels, call2species):
    """reduce the features two 2D by appling PCA and extracting the first two principal components """
    X = PCA(n_components=2).fit_transform(features)
    labels_ = set(labels)
    labels_ = dict(zip(labels_, range(len(labels_))))
    specie = [call2species[x] for x in labels]
    return pd.DataFrame({'labels':labels,'PC1': X[:,0], 'PC2': X[:,1], 'specie': specie})


def separate_calls(abx, calls):
    """For each list in calls will assign 'same' in the column  'type' if calls occur in both 'call_1' 
    and 'call_2', and 'diff' for the cross product of calls list. 
    """
    
    for call in calls.itervalues():
        # different calls
        for c1, c2 in product(call, call):
            if c1 == c2:
                pass
            idx = abx.query("""call_1 in @c2 and call_2 in @c1 or call_1 in @c1 and call_2 in @c2 """).index.values
            abx.loc[idx, 'type'] = "diff"
            
        # same calls
        for c in call:
            idx = abx.query("""call_1 in @c and call_2 in @c""").index.values
            abx.loc[idx, 'type'] = "same"

        
    return abx


def plot_labels(feat, title):
    """produce two plots:
    - left one have the projection in 2D by using PCA of the features (fix size window)
    - rigth has the same plot but the colors are set by call type 
    """
    param = {'kind':'scatter', 'x':'PC1', 'y':'PC2', 'sharex':True, 'sharey':True, 'legend':True, 's':10} 
    
    fig, ax = plt.subplots(1, 2, figsize=(20, 10), sharex=True, sharey=True, 
                           gridspec_kw = {'wspace':0.01, 'hspace':0.01},
                           subplot_kw={'xticks': [], 'yticks': [], 'aspect':'equal'})

    def do_fig(feat, title):
        color_specie = feat['specie'].unique()
        rgb_values = sns.color_palette("hls", len(color_specie))
        color_map = dict(zip(color_specie, rgb_values))
        grouped = feat.groupby('specie')
        for key, group in grouped:
            group.plot(ax=ax[0], label=key, color=group['specie'].map(color_map), **param)
            ax[0].set_ylabel('')
            ax[0].set_xlabel('')
            ax[0].legend(loc='lower center', ncol=8)

        color_labels = feat['labels'].unique()
        rgb_values = sns.color_palette("hls", len(color_labels))
        color_map = dict(zip(color_labels, rgb_values))
        grouped = feat.groupby('labels')
        for key, group in grouped:
            group.plot(ax=ax[1], label=key, color=group['labels'].map(color_map), **param)
            ax[1].set_ylabel('')
            ax[1].set_xlabel('')
            ax[1].legend(loc='lower center', ncol=8)
    do_fig(feat, title)
    plt.show()
