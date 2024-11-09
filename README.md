# LICENSE ME
Plugin to help generate licenses and comply with copyright notice in Godot Engine.

### Definition
Custom License: This is the license generated by the plugin.

## Features
- Create a file with/without custom license and include all the licenses included in your project when exporting.
- Add a dock for configure parameters and manual bake licenses.
- Includes GUI __(LicenseMeGUI)__ to view all licenses defined in your project and the licenses of the libraries.
- Include option in ProjectSettings (application/license) for print license notice in console.

## Use Case
If you don't have a license and are having trouble creating one or you just want all the licenses scattered around your project to be gathered into one file when you export your project this plugin will help you.

_It will also include the licenses that the engine uses._

### LICENSE NOTICE SUPPORTED
- AGPL-3.0
- APACHE-2.0
- BSD-3.0
- CC-BY-4.0
- CC-BY-NC-4.0
- CC-BY-NC-SA-4.0
- CC-BY-SA-4.0
- CC-ZERO-1.0
- COPYRIGHT
- EUPL-1.2_EN
- GPL-2.0
- GPL-3.0
- ISC
- LGPL-3.0
- MIT
- MPL-2.0
- UNLICENSE

## How Work
When you enable this plugin, it is ready to create a copyright license type when you export the project.
The License Me dock will also be activated, you can change any parameter you want.

### Auto create file with All licenses and Custom License
Just go to export your project and the folder you exported it to, you will be able to see the generated license.

- A different selected license type is required than __IGNORE__

### Auto create file with All licenses without Custom License
Select the license type as __IGNORE__ and go to export your project and the folder you exported it to, you will be able to see the generated license.

### Manual Bake License
In the dock, just press Bake manually, select the option you want and press the bake license, after selecting the path, you can go to the file to check. 

- If you selected **IGNORE** as the selected license type in the dock, the custom license will not be generated.

### DOCK PREVIEW
(Located on the side of the system folder)

![image](https://github.com/user-attachments/assets/f1b157f6-8566-4c1c-8950-70f310e4db2c)

You can check or uncheck clauses when using the copyright license type. 