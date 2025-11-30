@tool
extends Node


class Zip:
	const ADDON_PARENT_DIR :String = "addons/"

	static func extract_all_from_zip(zip_file: String, dest_dir: String, subfolder: String="") -> void:
		var reader: ZIPReader = ZIPReader.new()
		reader.open(zip_file)

		var root_dir: DirAccess = DirAccess.open(dest_dir)
		var zip_file_path:String = ""
		var files: Array[String] = []
		files.assign(reader.get_files())


		if(subfolder.contains(ADDON_PARENT_DIR)):
			# Filter all the files that have the addons subfolder
			files = files.filter(func(file): return file.contains(subfolder))

			var _zip_file_index:int = files[0].find(ADDON_PARENT_DIR)
			zip_file_path = files[0].substr(0, _zip_file_index + ADDON_PARENT_DIR.length())

			AceLog.printLog(["Zip File Path: %s" % zip_file_path], AceLog.LOG_LEVEL.DEBUG)

			#Remove everything including and before the addons/ folder in the subfolder path
			var subFileList: Array = files.map(func(file) -> String:
				var index: int = file.find(ADDON_PARENT_DIR)
				return file.substr(index + ADDON_PARENT_DIR.length())
			)

			var newFiles: Array[String] = []
			newFiles.assign(subFileList)
			files = newFiles

		else:
			AceLog.printLog(["The subfolder %s does not contain the required addons/ parent folder. Ignoring subfolder." % subfolder], AceLog.LOG_LEVEL.WARN)

		
		AceLog.printLog(["Extracting files from zip: %s" % zip_file, files ], AceLog.LOG_LEVEL.DEBUG)
		for file_path in files:
			if file_path.ends_with("/"):
				# It's a directory
				root_dir.make_dir_recursive(file_path)
				continue
		
			root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
			var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
			var buffer = reader.read_file(zip_file_path + file_path)
			file.store_buffer(buffer)
	

	static func read_zip_file(zip_file: String, file: String) -> PackedByteArray:
		var reader: ZIPReader = ZIPReader.new()
		var err = reader.open(zip_file)
		if err != OK:
			return PackedByteArray()
		var res = reader.read_file(file)
		reader.close()
		return res