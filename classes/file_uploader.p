##############################################################################
@file[sFilePath;sFileName;oObject][file_icons;src;ext;ico]
	$file_icons[
		$.GIF[GIF]
		$.JPG[JPG]
		$.JPEG[JPEG]
		$.PNG[PNG]
		$.PSD[PSD]
		$.ZIP[ZIP]
		$.TAR[TAR]
		$.GZ[TGZ]
		$.TGZ[TGZ]
		$.TXT[TXT]
		$.HTML[HTML]
		$.SWF[SWF]
		$.PDF[PDF]
		$.DOC[DOC]
		$.DOCX[DOC]
		$.XLS[XLS]
		$.XLSX[XLS]
		$.PPT[PPT]
		$.PPTX[PPT]
		$._default[Generic]
	]

	$src[$sFilePath/$sFileName]
	$ext[^file:justext[$sFileName]]
	$only_name[^file:justname[$sFileName]]
	$ico[$file_icons.[^ext.upper[]]]

	$result[
		$.parent_id[^if($oObject){$oObject.id}{0}]
		$.name[$sFileName]
		$._name[$only_name]
		$.ext[$ext]
		$.ico[$ico]
		$.src[$src]
		$.hash[^math:md5[$sFileName]]
		$.stat[^file::stat[$src]]
	]
#end @file[]



##############################################################################
@files[oObject;sFileMask]
	$file_path[^object_file_path[$oObject]]
	$files[^file:list[$file_path/;^if(def $sFileMask){(^^[^^.]|$sFileMask)}{^^[^^.]}]]

	$result[^array::create[]]

	^files.menu{
		$src[$file_path/$files.name]

		^if(-f $src){
			^result.add[^file[$file_path;$files.name;$oObject]]
		}
	}
#end @files[]




##############################################################################
@images[oObject;sFileMask]
	$file_path[^object_file_path[$oObject]]
	$files[^file:list[$file_path/;^if(def $sFileMask){(^^[^^.]|$sFileMask)}{^^[^^.]}]]

	$result[^array::create[]]

	^files.menu{
		$src[$file_path/$files.name]

		^if(-f $src){
			^try{
				$file_info[^file[$file_path;$files.name;$oObject]]

				$image[^image::measure[$file_info.src]]

				^result.add[$file_info]
			}{
				$exception.handled(true)
			}			
		}
	}
#end @files[]