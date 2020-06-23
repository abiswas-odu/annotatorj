# Intro

This repository contains the codes for the ImageJ plugin AnnotatorJ which aims to ease object annotation. An exporter plugin, AnnotatorJExporter is also included.

A detailed user manual is provided in [**AnnotatorJ_documentation.pdf**](AnnotatorJ_documentation.pdf) in this repository.

# Prerequisites

To use this tool you need to:

- Install [JDK 1.8](https://www.oracle.com/java/technologies/javase-jdk8-downloads.html)
- (optional) Download [ImageJ](https://imagej.nih.gov/ij/download.html) or [Fiji](https://fiji.sc/) (Fiji is just ImageJ)

# Installation

## Building from source

1. Clone this repository with

	```
		git clone https://github.com/spreka/annotatorj.git
	```

2. Install [maven](https://maven.apache.org/download.cgi) according to your operating system
	- on Windows:
		- Download *apache-maven-x.x.x-bin.zip* and extract it
		- Add the path to the extracted folder to your system Path variable
	- on Linux:
		- run the following command with a sudo user

			```
				sudo apt install maven
			```

3. Verify maven installation by running the following command:

	```
		mvn --version
	```

	This should display version information of your maven install.  

4. Install custom dependencies found in */lib/* by executing the commands in *mvn install.txt*

```
	mvn install:install-file -Dfile="lib\javabuilder.jar" -DgroupId=com.mathworks.toolbox -DartifactId=javabuilder -Dversion=9.2.0.538062 -Dpackaging=jar
	mvn install:install-file -Dfile="lib\runAC.jar" -DgroupId=com.mathworks -DartifactId=runAC -Dversion=1.0 -Dpackaging=jar
```

5. (optional) Edit the file *pom.xml* and uncomment either of the following lines to set the ImageJ/Fiji install folder to your installed ImageJ/Fiji folder during building:
  

```xml  
	<imagej.app.directory>D:\ImageJ\ImageJ</imagej.app.directory>
	<scijava.app.directory>d:\FIJI\Fiji.app\</scijava.app.directory>
```

6. Build the plugin:
  

```shell  
	mvn clean install
	# optionally, set the Fiji install folder here:
	# mvn clean install -Dscijava.app.directory=d:\FIJI\Fiji.app\
```


NOTE: Building from source is also possible using an IDE e.g. Eclipse. See the [documentation](AnnotatorJ_documentation.pdf) for instructions.

## Using a release version

A [standalone built version](https://github.com/spreka/annotatorj/releases/tag/v0.0.2-alpha) that only contains the core ImageJ functionality and this plugin is provided.
Currently, Windows and Linux versions are available.

No installation is needed for releases; simply extract the archive to any empty folder on your computer.
The standalone version starts the AnnotatorJ plugin on startup.

## Using Fiji updater

The update site of AnnotatorJ is:
	
- URL: https://sites.imagej.net/Spreka/
- Name: AnnotatorJ

To add this update site to your Fiji installation, please follow [this tutorial](https://imagej.net/Following_an_update_site) on imagej.net.


# Usage

To start using the annotation tool after installation:

- **Pre-built version**
	- Start Fiji
	- Navigate to *Plugins*-->*AnnotatorJ*

- **Standalone version**
	- Locate */your/extracted/path/annotator_Project-0.0.1-SNAPSHOT.jar*
	- Add execution permission to this .jar file
	- Run the .jar file

This will open the AnnotatorJ plugin in a new window.
First you need to open a new image and select the type of annotation you would like to do from the list

- [instance](#instance-segmentation)
- [semantic](#semantic-segmentation)
- [bounding box](#bounding-box-annotation)


An overview of the annotation types is demonstrated below.
Please check [our guide](#how-to-annotate) for a quick overview of the functionalities of the plugin.

![example_annottypes][annotexporttypes]

The figure also shows how the given annotation types can be exported with the supplemented [exporter plugin](#export).


## Instance segmentation

This type of segmentation means the boundaries of the objects are marked with contours for each individual object separately. We automatically select the *Freehand selection* tool for you which will close the running line you draw when the left mouse button is released, resulting in a closed contour. See a demonstration above.

Such a segmentation is used to generate labelled masks of the individual objects (multi-label image above).

## Semantic segmentation

Objects are considered foreground while everything else on the image is background. Objects are marked with a paint brush to create a binary (black and white) image.

## Bounding box annotation

Rectangles are drawn to enclose individual objects. We automatically select the *Rectangle selection* tool for you which can drag the marked points on the corners and the sides of the rectangle.
The position and size of the objects is stored in the coordinates of the rectangles identified.

***
## How to annotate

1. Open --> opens an image
2. Select annotation type --> a default tool is selected from the toolbar that fits the selected annotation type
3. Start annotating objects
	- instance: draw contours around objects
	- semantic: paint the objects' area
	- bounding box: draw rectangles around the objects
4. Save --> Select class --> saves the annotation to a file in a sub-folder of the original image folder with the name of the selected class

5. (Optionally)
	- Load --> continue a previous annotation
	- Overlay --> display a different annotation as overlay (semi-transparent) on the currently opened image
	- Colours --> select annotation and overlay colours
	- ... --> set options for semantic segmentation and *Contour assist* mode
	- checkboxes --> Various options
		- Add automatically --> adds the most recent annotation to the ROI list automatically when releasing the left mouse button
		- Smooth --> smooths the contour (in instance annotation type only)
		- Show contours --> displays all the contours in the ROI list
		- Contours assist --> suggests a contour in the region of an initial, lazily drawn contour using the deep learning method U-Net
		- Show overlay --> displays the overlayed annotation if loaded with the Overlay button
		- Edit mode --> edits a selected, already saved contour in the ROI list by clicking on it on the image
		- Class mode --> assigns the selected class to the selected contour in the ROI list by clicking on it on the image and displays its contour in the class's colour (can be set in the Class window); clicking on the object a second time unclassifies it
	- [^] --> quick export in 16-bit multi-labelled .tiff format; if classified, also exports by classes

***

## Contour assist

To use this functionality, a trained keras U-Net model must be provided. The default location is the */plugins/models/* folder of your ImageJ/Fiji installation or the standalone release of this plugin. The default names of the model and config file are *model_real.json* and *model_real_weights.h5*.
You can change these names and the path in the file *AnnotatorJconfig.txt* automatically created when first running the plugin, in the default */plugins/models/* folder.

An example pre-trained model trained on nucleus images can be downloaded from the [Releases](https://github.com/spreka/annotatorj/releases/tag/v0.0.2-model) page of this repository.
You can also train a new one on your own data in e.g. Python and save it with this code block:

```python
	# save model as json
	model_json=model.to_json()
	with open(‘model_real.json’, ‘w’) as f:
		f.write(model_json)
	
	# save weights too
	model.save_weights(‘model_real_weights.h5’)

```

# OpSeF import

To start using the plugin on OpSeF data:

- **Pre-built version**
	- Start Fiji
	- Navigate to *Plugins*-->*AnnotatorJOpSef*

- **Standalone version**
	- Locate */your/extracted/path/annotator_Project-0.0.1-SNAPSHOT.jar*
	- Add execution permission to this .jar file
	- Run the .jar file
	- The *AnnotatorJ* plugin will open at startup, close it
	- Navigate to *Plugins*-->*AnnotatorJOpSef*

This will open the AnnotatorJOpSef plugin in a new window.
First you need to locate the *FilePairList* text file in your OpSeF project folder under *10_ImportExport*.
The selected file instructs the plugin to either load basic segmentation masks from the *02_SegMasks* or classified segmentation masks from the *07_ClassifiedSegMasks* folder.
If previously saved annotations created in AnnotatorJ exist in the temporary working folder *12_TmpRoisFromFiji* following AnnotatorJ naming conventions, they will be loaded instead of the mask files in the selected *FilePairList* text file.

A default class can be set to all unassigned objects in the drop-down list of *Classes* window (opened by selecting the checkbox *Class mode* in the main window of the plugin).
Only objects assigned to one of the classes will be exported as class masks to ouput folder *13_ClassifiedSegMasksFromFiji*, while all objects will be exported as segmentation masks to output folder *11_SegMasksFromFiji*. Grayscale values of segmentation masks are preserved.

Note: If the same colour as the current annotation colour is selected for a class, the class assignment operation will not be visible! It is suggested to use distinct colours.

## Segmentation mask import

16-bit multi-labelled segmentation masks created in OpSeF will be imported for editing and/or classification (see [instructions](#how-to-annotate) or [documentation](AnnotatorJ_documentation.pdf)).

## Classified mask import

16-bit multi-labelled segmentation masks created and classified in OpSeF will be imported for editing and/or classification (see [instructions](#how-to-annotate) or [documentation](AnnotatorJ_documentation.pdf)).
Classes will be marked with different contour colours.


# Export

An exporter plugin, AnnotatorJExporter is also included in this repository for the fast and easy export of annotations.
The folder structure required by the exporter is as follows:

```
image_folder
	|--- image1.png
	|--- another_image.png
	|--- something.png
	|--- ...

annotation_folder
	|--- image1_ROIs.zip
	|--- another_image_ROIs.zip
	|--- something_ROIs.zip
	|--- ...
```

This structure is created by the AnnotatorJ plugin such that the *annotation folder* is created as a sub-folder of the *image folder* with the name of the selected annotation class (see the [documentation](AnnotatorJ_documentation.pdf)).

Possible export options are displayed above.

# Citation

If you use the plugin, please cite our corresponding publication: [...]


[annotexporttypes]: demos/annotation_and_export_types.png "Annotation and export types"