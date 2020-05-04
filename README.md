Contour Detection

INTRODUCTION
===================================================================================
This code is provided for research purpose only. 
This code performs the contour detection by simulating the curvature cell in the Visual Cortex reported in:

**Citation：Z. Chen and R. Cai, "Contour Detection by Simulating the Curvature Cell in the Visual Cortex and its Application to Object Classification," in IEEE Access, vol. 8, pp. 74472-74484, 2020.**

**ABSTRACT**
This paper addresses contour detection by simulating the human visual system and its application to visual object classification. Unlike previously designed bioinspired contour detection algorithms, we consider contour to be the salience of an edge image, and  we extract the salience by simulating the endstopped cell and curvature cell in the visual cortex. Generally, we follow a local-to-global feed-forward architecture, in which the size of the receptive field (RF) increases from the primary visual cortex to the higher visual cortex. Edges are first detected by simple cells in small RFs, where textural details are suppressed by non-classical receptive fields (NCRFs) and sparse coding. Second, edges are integrated into local segments by complex cells. Afterwards, they are combined into the salience of edge images by endstopped cells and curvature cells and are ultimately the core of the final contour. In addition, we also apply the bioinspired contour detection algorithm to visual object classification tasks. Experiments on contour extraction show that, compared with state-of-the-art bioinspired algorithms, our algorithm makes a considerable improvement on contour detection. Experiments on visual object classification show that the contours produced by our proposal are powerful representations of the original images, which implies that our proposal is both biologically plausible and technologically useful.
**https://ieeexplore.ieee.org/document/9069915**

Please cite our paper if this code is used to motivate any publications.

To detect contour with the model to an image,run **"Demo.m"** for an example.

if you want to apply this algorithm to the BSDS500 and the BSDS300 dataset, you will need to download and install the code for applying benchmark, which is available： **http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/segbench/**

Let us know if you have any questions at Rongtai Cai **gjrtcai@163.com**
