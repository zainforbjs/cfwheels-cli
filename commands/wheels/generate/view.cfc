/**
 * I generate a view file in /views/VIEWNAME/NAME.cfm
 *
 * Create a default file called show.cfm without a template
 *
 * {code:bash}
 * wheels generate view user show
 * {code}
 *
 * Create a default file called show.cfm using the default CRUD template
 *
 * {code:bash}
 * wheels generate view user show crud/show
 * {code}
 **/
component aliases='wheels g view' extends="../base"  {

	/**
	 * @objectname.hint View path folder, i.e user
	 * @name.hint Name of the file to create, i.e, edit
	 * @template.hint optional template (used in Scaffolding)
	 * @template.options crud/_form,crud/edit,crud/index,crud/new,crud/show
	 **/
	function run(
		required string objectname,
		required string name,
		string template=""
	){
		var obj = helpers.getNameVariants(listLast( arguments.objectname, '/\' ));
		var viewdirectory     = fileSystemUtil.resolvePath( "views" );
		var directory 		  = fileSystemUtil.resolvePath( "views" & "/" & obj.objectNamePlural);
		print.line( "Creating View File..." ).toConsole();

		// Validate directory
		if( !directoryExists( viewdirectory ) ) {
			error( "[#arguments.viewdirectory#] can't be found. Are you running this from your site root?" );
 		}

 		// Validate views subdirectory, create if doesnt' exist
 		if( !directoryExists( directory ) ) {
 			print.line( "#directory# doesnt exist... creating" ).toConsole();
 			directoryCreate(directory);
 			print.line( "#directory# created" ).toConsole();
 		}

 		// Read in Template
		var viewContent 	= "";
 		if(!len(arguments.template)){
 			viewContent 	= fileRead( getTemplate( '/viewContent.txt'));
		} else {
			viewContent 	= fileRead( getTemplate( arguments.template & '.txt'));
		}
		// Replace Object tokens
		viewContent=$replaceDefaultObjectNames(viewContent, obj);
		var viewName = lcase(arguments.name) & ".cfm";
		var viewPath = directory & "/" & viewName;

		if(fileExists(viewPath)){
			if( confirm( '#viewName# already exists in target directory. Do you want to overwrite? [y/n]' ) ) {
			    print.greenLine( 'Ok, going to overwrite...' ).toConsole();
			} else {
			    print.boldRedLine( 'Ok, aborting!' );
			    return;
			}
		}
		file action='write' file='#viewPath#' mode ='777' output='#trim( viewContent )#';
		print.line( 'Created #viewName#' );
	}
}