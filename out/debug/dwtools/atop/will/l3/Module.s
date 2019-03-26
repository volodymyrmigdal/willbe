( function _Module_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

//

let _ = wTools;
let Parent = null;
let Self = function wWillModule( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Module';

// --
// inter
// --

function finit()
{
  let module = this;
  let will = module.will;

  module.unform();
  module.about.finit();
  module.execution.finit();

  _.assert( _.instanceIsFinited( module.about ) );
  _.assert( _.instanceIsFinited( module.execution ) );

  _.assert( Object.keys( module.exportedMap ).length === 0 );
  _.assert( Object.keys( module.buildMap ).length === 0 );
  _.assert( Object.keys( module.stepMap ).length === 0 );
  _.assert( Object.keys( module.reflectorMap ).length === 0 );
  _.assert( Object.keys( module.pathResourceMap ).length === 0 );
  _.assert( Object.keys( module.submoduleMap ).length === 0 );

  _.assert( module.willFileArray.length === 0 );
  _.assert( Object.keys( module.willFileWithRoleMap ).length === 0 );
  _.assert( will.moduleMap[ module.id ] !== module );
  _.assert( !_.arrayHas( will.moduleArray, module ) );

  return _.Copyable.prototype.finit.apply( module, arguments );
}

//

function init( o )
{
  let module = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  module.pathResourceMap = module.pathResourceMap || Object.create( null );

  _.instanceInit( module );
  Object.preventExtensions( module );

  module.Counter += 1;
  module.id = module.Counter;

  let will = o.will;
  _.assert( !!will );

  module.stager = new _.Stager
  ({
    object : module,
    stageNames : [ 'preformed', 'willFilesFound', 'willFilesOpened', 'submodulesFormed', 'resourcesFormed', 'totallyFormed' ],
    consequenceNames : [ 'preformRady', 'willFilesFindReady', 'willFilesOpenReady', 'submodulesFormReady', 'resourcesFormReady', 'ready' ],
    finals : [ 3, 3, 3, 3, 3, 1 ],
    verbosity : Math.max( Math.min( will.verbosity, will.verboseStaging ), will.verbosity - 6 ),
  });

  if( o )
  module.copy( o );

}

//

function copy( o )
{
  let module = this;

  if( o && o.will )
  module.will = o.will;

  // let names =
  // {
  //   submoduleMap : null,
  //   pathResourceMap : null,
  //   reflectorMap : null,
  //   stepMap : null,
  //   buildMap : null,
  //   exportedMap : null,
  // }
  //
  // for( let n in names )
  // {
  //   if( o[ n ] !== undefined )
  //   module[ n ] = o[ n ];
  // }

  let result = _.Copyable.prototype.copy.apply( module, arguments );

  let names =
  {
    filePath : null,
    dirPath : null,
    clonePath : null,
    remotePath : null,
  }

  for( let n in names )
  {
    if( o[ n ] !== undefined )
    module[ n ] = o[ n ];
  }

  return result;
}

//

function unform()
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 0 );

  if( module.associatedSubmodule )
  {
    _.assert( module.associatedSubmodule.loadedModule === module );
    module.associatedSubmodule.loadedModule = null;
    module.associatedSubmodule.finit();
  }

  /* begin */

  for( let i in module.exportedMap )
  module.exportedMap[ i ].finit();
  for( let i in module.buildMap )
  module.buildMap[ i ].finit();
  for( let i in module.stepMap )
  module.stepMap[ i ].finit();
  for( let i in module.reflectorMap )
  module.reflectorMap[ i ].finit();
  for( let i in module.pathResourceMap )
  module.pathResourceMap[ i ].finit();
  for( let i in module.submoduleMap )
  module.submoduleMap[ i ].finit();

  _.assert( Object.keys( module.exportedMap ).length === 0 );
  _.assert( Object.keys( module.buildMap ).length === 0 );
  _.assert( Object.keys( module.stepMap ).length === 0 );
  _.assert( Object.keys( module.reflectorMap ).length === 0 );
  _.assert( Object.keys( module.pathResourceMap ).length === 0 );
  _.assert( Object.keys( module.submoduleMap ).length === 0 );

  for( let i = module.willFileArray.length-1 ; i >= 0 ; i-- )
  {
    let willf = module.willFileArray[ i ];
    _.assert( Object.keys( willf.submoduleMap ).length === 0 );
    _.assert( Object.keys( willf.reflectorMap ).length === 0 );
    _.assert( Object.keys( willf.stepMap ).length === 0 );
    _.assert( Object.keys( willf.buildMap ).length === 0 );
    willf.finit();
  }

  _.assert( module.willFileArray.length === 0 );
  _.assert( Object.keys( module.willFileWithRoleMap ).length === 0 );
  _.assert( will.moduleMap[ module.remotePath ] === undefined );

  if( module.preformed )
  {
    if( will.moduleMap[ module.id ] === module );
    delete will.moduleMap[ module.id ];
    _.arrayRemoveElementOnceStrictly( will.moduleArray, module );
  }

  _.assert( will.moduleMap[ module.filePath ] !== module );
  _.assert( will.moduleMap[ module.id ] !== module );
  _.assert( !_.arrayHas( will.moduleArray, module ) );

  /* end */

  module.preformed = 0;
  return module;
}

//

function preform()
{
  let module = this;
  let will = module.will;
  let con = new _.Consequence().take( null );

  _.assert( arguments.length === 0 );
  _.assert( !module.preformRady.resourcesCount() )
  _.assert( !module.preformed );

  if( module.preformed > 0 )
  return module.stager.stageConsequence( 'preformed' );
  module.stager.stageState( 'preformed', 1 );
  module.stager.stageState( 'preformed', 2 );

  con.keep( () => module.preform1() );
  con.keep( () => module.preform2() );
  con.finally( ( err, arg ) =>
  {
    if( err )
    throw module.stager.stageError( 'preformed', err );
    else
    module.stager.stageState( 'preformed', 3 );
    return arg;
  });

  return module;
}

//

function preform1()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module.will );
  _.assert( _.strIs( module.filePath ) || _.strIs( module.dirPath ), 'Expects filePath or dirPath' );

  if( module.filePath === null )
  module.filePath = module.dirPath;

  module._filePathChange( module.filePath, module.dirPath );

  /* */

  _.assert( module.id > 0 );
  will.moduleMap[ module.id ] = module;
  _.arrayAppendOnceStrictly( will.moduleArray, module );
  _.assert( will.moduleMap[ module.id ] === module );

  return module;
}

//

function preform2()
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 0 );
  _.assert( module.preformed === 2 );
  _.assert( !!module.will );
  _.assert( will.moduleMap[ module.id ] === module );
  _.assert( module.dirPath === null || _.strDefined( module.dirPath ) );
  _.assert( !!module.filePath );

  module.predefinedForm();
  module.remoteForm();

  return module;
}

//

function predefinedForm()
{
  let module = this;
  let will = module.will;
  let Predefined = will.Predefined;

  _.assert( arguments.length === 0 );

  /* */

  path
  ({
    name : 'filePath',
    path : null,
  })

  path
  ({
    name : 'dirPath',
    path : null,
  })

  path
  ({
    name : 'clonePath',
    path : null,
  })

  path
  ({
    name : 'remotePath',
    path : null,
  })

  path
  ({
    name : 'willPath',
    path : _.path.join( __dirname, '../Exec' ),
  })

  /* */

  step
  ({
    name : 'predefined.delete',
    stepRoutine : Predefined.stepRoutineDelete,
  })

  step
  ({
    name : 'predefined.reflect',
    stepRoutine : Predefined.stepRoutineReflect,
  })

  step
  ({
    name : 'timelapse.begin',
    stepRoutine : Predefined.stepRoutineTimelapseBegin,
  })

  step
  ({
    name : 'timelapse.end',
    stepRoutine : Predefined.stepRoutineTimelapseEnd,
  })

  step
  ({
    name : 'predefined.js',
    stepRoutine : Predefined.stepRoutineJs,
  })

  step
  ({
    name : 'predefined.shell',
    stepRoutine : Predefined.stepRoutineShell,
  })

  step
  ({
    name : 'predefined.transpile',
    stepRoutine : Predefined.stepRoutineTranspile,
  })

  step
  ({
    name : 'predefined.view',
    stepRoutine : Predefined.stepRoutineView,
  })

  step
  ({
    name : 'submodules.download',
    stepRoutine : Predefined.stepRoutineSubmodulesDownload,
  })

  step
  ({
    name : 'submodules.upgrade',
    stepRoutine : Predefined.stepRoutineSubmodulesUpgrade,
  })

  step
  ({
    name : 'submodules.reload',
    stepRoutine : Predefined.stepRoutineSubmodulesReload,
  })

  step
  ({
    name : 'submodules.clean',
    stepRoutine : Predefined.stepRoutineSubmodulesClean,
  })

  step
  ({
    name : 'clean',
    stepRoutine : Predefined.stepRoutineClean,
  })

  step
  ({
    name : 'predefined.export',
    stepRoutine : Predefined.stepRoutineExport,
  })

  /* */

  reflector
  ({
    name : 'predefined.common',
    src :
    {
      maskAll :
      {
        excludeAny :
        [
          /(\W|^)node_modules(\W|$)/,
          /\.unique$/,
          /\.git$/,
          /\.svn$/,
          /\.hg$/,
          /\.DS_Store$/,
          /(^|\/)-/,
        ],
      }
    },
  });

  reflector
  ({
    name : 'predefined.debug',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.release($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 1,
    },
  });

  reflector
  ({
    name : 'predefined.release',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.debug($|\.|\/)/i, /\.test($|\.|\/)/i, /\.experiment($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 0,
    },
  });

/*
  .predefined.common :
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/(^|\/)-/'

  .predefined.debug :
    inherit : .predefined.common
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/\.release($|\.|\/)/i'

  .predefined.release :
    inherit : .predefined.common
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/\.debug($|\.|\/)/i'
        - !!js/regexp '/\.test($|\.|\/)/i'
        - !!js/regexp '/\.experiment($|\.|\/)/i'
*/

  /* - */

  function path( o )
  {

    if( module.pathResourceMap[ o.name ] )
    return module.pathResourceMap[ o.name ].form1();

    let defaults =
    {
      module : module,
      criterion :
      {
        predefined : 1,
      }
    }

    o.criterion = o.criterion || Object.create( null );

    _.mapSupplement( o, defaults );
    _.mapSupplement( o.criterion, defaults.criterion );

    _.assert( o.criterion !== defaults.criterion );
    _.assert( arguments.length === 1 );

    let result = new will.PathResource( o ).form1();
    result.writable = 0;
    return result;
  }

  /* */

  function step( o )
  {
    if( module.stepMap[ o.name ] )
    return module.stepMap[ o.name ].form1();

    let defaults =
    {
      module : module,
      criterion :
      {
        predefined : 1,
      }
    }

    o.criterion = o.criterion || Object.create( null );

    _.mapSupplement( o, defaults );
    _.mapSupplement( o.criterion, defaults.criterion );

    _.assert( o.criterion !== defaults.criterion );
    _.assert( arguments.length === 1 );

    let result = new will.Step( o ).form1();
    result.writable = 0;
    return result;
  }

  /* */

  function reflector( o )
  {
    if( module.reflectorMap[ o.name ] )
    return module.reflectorMap[ o.name ].form1();

    let defaults =
    {
      module : module,
      criterion :
      {
        predefined : 1,
      }
    }

    o.criterion = o.criterion || Object.create( null );

    _.mapSupplement( o, defaults );
    _.mapSupplement( o.criterion, defaults.criterion );

    _.assert( o.criterion !== defaults.criterion );
    _.assert( arguments.length === 1 );

    let result = new will.Reflector( o ).form1();
    result.writable = 0;
    return result;
  }

}

//

function shell( command )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( _.strIs( command ) );
  _.assert( arguments.length === 1 );

  return _.shell
  ({
    execPath : command,
    currentPath : module.dirPath,
    verbosity : will.verbosity-1,
  });

}

//

function hasAnyError()
{
  let module = this;
  let will = module.will;
  return !!module.ready.errorsCount();
}

//

function cleanWhat( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let exps = module.exportsSelect();
  let filePaths = [];
  let result = Object.create( null );
  result[ '/' ] = filePaths;

  o = _.routineOptions( cleanWhat, arguments );

  /* submodules */

  if( o.cleaningSubmodules )
  {

    let submodulesCloneDirPath = module.submodulesCloneDirGet();
    find( submodulesCloneDirPath );

  }

  /* out */

  if( o.cleaningOut )
  {
    let files = [];

    for( let e = 0 ; e < exps.length ; e++ )
    {
      let exp = exps[ e ];
      let archiveFilePath = exp.archiveFilePathFor();
      let outFilePath = exp.outFilePathFor();
      _.arrayAppendArrayOnce( files, [ archiveFilePath, outFilePath ] );
    }

    find( files );
  }

  /* temp dir */

  if( o.cleaningTemp )
  {
    let temp;

    temp = module.reflectorResolve
    ({
      selector : 'reflector::temp',
      pathResolving : 'in',
      missingAction : 'undefine',
    });

    if( temp )
    {
      let o2 = temp.optionsForFindExport();
      find( o2 );
    }

    if( !temp )
    {
      temp = module.pathResolve
      ({
        selector : 'path::temp',
        pathResolving : 'in',
        missingAction : 'undefine',
      });

      if( !temp )
      temp = [];

      temp = _.arrayAs( path.s.join( module.inPath, temp ) );

      for( let p = 0 ; p < temp.length ; p++ )
      {
        let filePath = temp[ p ];
        find( filePath );
      }

    }

  }

  filePaths.sort();

  return result;

  /* - */

  function find( op )
  {

    if( _.arrayIs( op ) || _.strIs( op ) )
    op = { filter : { filePath : op } }

    if( _.arrayIs( op.filter.filePath.length ) && !op.filter.filePath.length )
    return;

    let def =
    {
      verbosity : 0,
      allowingMissed : 1,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      maskPreset : 0,
      outputFormat : 'absolute',
      writing : 0,
      deletingEmptyDirs : 1,
    }

    _.mapSupplement( op, def );

    let found = fileProvider.filesDelete( op );
    _.assert( op.filter.formed === 5 );
    let filePath = path.pathMapSrcFromSrc( op.filter.filePath );
    let commonPath = filePath.length ? path.detrail( path.common( filePath ) ) : '';

    found = _.arrayFlattenOnce( found );

    if( found.length )
    _.arrayFlattenOnce( filePaths, found );

    if( found.length )
    for( let p in result )
    {
      if( !_.strHas( commonPath, p ) )
      continue;
      if( p === '/' )
      continue;
      if( !result[ commonPath ] )
      result[ commonPath ] = found;
      else
      _.arrayFlattenOnce( result[ commonPath ], found );
      found = [];
      break;
    }

    if( found.length )
    if( !result[ commonPath ] )
    result[ commonPath ] = found;
    else
    _.arrayFlattenOnce( result[ commonPath ], found );

  }

}

cleanWhat.defaults =
{
  cleaningSubmodules : 1,
  cleaningOut : 1,
  cleaningTemp : 1,
}

//

function clean()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let time = _.timeNow();
  let files = module.cleanWhat.apply( module, arguments );

  _.assert( _.arrayIs( files[ '/' ] ) );

  for( let f = files[ '/' ].length-1 ; f >= 0 ; f-- )
  {
    let filePath = files[ '/' ][ f ];
    _.assert( path.isAbsolute( filePath ) );
    fileProvider.fileDelete({ filePath : filePath, verbosity : 1, throwing : 0 });
  }

  if( logger.verbosity >= 2 )
  logger.log( ' - Clean deleted ' + files[ '/' ].length + ' file(s) in ' + _.timeSpent( time ) );

  return files;
}

clean.defaults = Object.create( cleanWhat.defaults );

// --
// opener
// --

function DirPathFromFilePaths( filePaths )
{
  let module = this;

  filePaths = _.arrayAs( filePaths );

  _.assert( _.strsAreAll( filePaths ) );
  _.assert( arguments.length === 1 );

  filePaths = filePaths.map( ( filePath ) =>
  {
    filePath = _.path.normalizeTolerant( filePath );

    let r1 = /(.*)(?:\.will(?:\.|$))[^\/]*$/;
    let parsed1 = r1.exec( filePath );
    if( parsed1 )
    filePath = parsed1[ 1 ];

    let r2 = /(.*)(?:\.(?:im|ex)(?:\.|$))[^\/]*$/;
    let parsed2 = r2.exec( filePath );
    if( parsed2 )
    filePath = parsed2[ 1 ];

    // if( parsed1 || parsed2 )
    // if( _.strEnds( filePath, '/' ) )
    // filePath = filePath + '.';

    return filePath;
  });

  let filePath = _.strCommonLeft.apply( _, filePaths );
  _.assert( filePath.length > 0 );
  return filePath;
}

//

function prefixPathForRole( role )
{
  let module = this;
  let result = module.prefixPathForRoleMaybe( role );

  _.assert( arguments.length === 1 );
  _.sure( _.strIs( result ), 'Unknown role', _.strQuote( role ) );

  return result;
}

//

function prefixPathForRoleMaybe( role )
{
  let module = this;

  _.assert( arguments.length === 1 );

  if( role === 'import' )
  return '.im.will';
  else if( role === 'export' )
  return '.ex.will';
  else if( role === 'single' )
  return '.will';
  else return null;

}

//

function isOpened()
{
  let module = this;
  return module.willFileArray.length > 0;
}

//

function stateResetError()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let resettingReady = 0;

  if( module.preformRady.errorsCount() )
  {
    _.assert( module.preformed === 1 );
    module.preformed = 0;
    module.preformRady.got( 1 );
    resettingReady = 1;
  }

  if( module.willFilesFindReady.errorsCount() )
  {
    _.assert( module.willFilesFound < 3 );
    module.willFilesFound = 0;
    module.willFilesFindReady.resourcesCancel();
    resettingReady = 1;
  }

  if( module.willFilesOpenReady.errorsCount() )
  {
    _.assert( module.willFilesOpened < 3 );
    module.willFilesOpened = 0;
    module.willFilesOpenReady.resourcesCancel();
    resettingReady = 1;
  }

  if( module.submodulesFormReady.errorsCount() )
  {
    _.assert( module.submodulesFormed < 3 );
    module.submodulesFormed = 0;
    module.submodulesFormReady.resourcesCancel();
    resettingReady = 1;
  }

  if( module.resourcesFormReady.errorsCount() )
  {
    _.assert( module.resourcesFormed < 3 );
    module.resourcesFormed = 0;
    module.resourcesFormReady.resourcesCancel();
    resettingReady = 1;
  }

  if( resettingReady )
  {
    module.ready.resourcesCancel()
  }

}

//

function willFilesPick( filePaths )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = [];

  filePaths = _.arrayAs( filePaths );

  _.assert( arguments.length === 1 );
  _.assert( _.strsAreAll( filePaths ) );

  module.willFilesReadBegin();

  if( module.willFilesFound > 0 )
  return module.stager.stageConsequence( 'willFilesFound' );
  module.stager.stageState( 'willFilesFound', 1 );
  module.stager.stageState( 'willFilesFound', 2 );

  try
  {

    filePaths.forEach( ( filePath ) =>
    {

      let willFile = new will.WillFile
      ({
        role : 'single',
        filePath : filePath,
        module : module,
      }).form1();

      if( !willFile.exists() )
      willFile.finit();
      else
      result.push( willFile );

    });

  }
  catch( err )
  {
    throw module.stager.stageError( 'willFilesFound', err );
  }

  // if( result.length )
  module.stager.stageState( 'willFilesFound', 3 );

  return result;
}

//

function _willFileFindMaybe( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.routineOptions( _willFileFindMaybe, arguments );

  _.assert( _.strDefined( o.role ) );
  _.assert( !module.willFilesFindReady.resourcesCount() );
  _.assert( !module.willFilesOpenReady.resourcesCount() );
  _.assert( !module.submodulesFormReady.resourcesCount() );
  _.assert( !module.resourcesFormReady.resourcesCount() );

  let dirPath = module.dirPath || path.dir( module.filePath );
  let namePath = '.';
  if( o.isNamed )
  namePath = path.fullName( path.parse( module.filePath ).longPath );

  if( module.willFileWithRoleMap[ o.role ] )
  return null;

  let filePath;
  if( o.isOutFile )
  {

    if( o.isNamed )
    {

      if( module.dirPath )
      dirPath = path.dir( module.dirPath );
      else
      dirPath = path.dir( module.filePath );
      let name = _.strJoinPath( [ namePath, '.out', module.prefixPathForRole( o.role ) ], '.' );
      filePath = path.resolve( dirPath, '.', name );
    }
    else
    {
      let name = _.strJoinPath( [ namePath, '.out', module.prefixPathForRole( o.role ) ], '.' );
      filePath = path.resolve( dirPath, name );
    }

  }
  else
  {

    if( o.isNamed )
    {
      if( module.dirPath )
      dirPath = path.dir( module.dirPath );
      else
      dirPath = path.dir( module.filePath );

      let name = _.strJoinPath( [ namePath, module.prefixPathForRole( o.role ) ], '.' );
      filePath = path.resolve( dirPath, '.', name );
    }
    else
    {

      if( module.dirPath )
      dirPath = module.dirPath;
      else
      dirPath = module.filePath;

      let name = module.prefixPathForRole( o.role );
      filePath = path.resolve( dirPath, namePath, name );

    }

  }

  if( will.verbosity >= 5 )
  logger.log( ' . Trying to open', filePath );

  _.assert( module.willFileWithRoleMap[ o.role ] === undefined )

  new will.WillFile
  ({
    role : o.role,
    filePath : filePath,
    module : module,
  }).form1();

  let result = module.willFileWithRoleMap[ o.role ];

  if( result.exists() )
  {
    return result;
  }
  else
  {
    result.finit();
    return null;
  }

}

_willFileFindMaybe.defaults =
{
  role : null,
  isOutFile : 0,
  isNamed : 0,
}

//

function _willFilesFindMaybe( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let filePaths;

  o = _.routineOptions( _willFilesFindMaybe, arguments );

  _.assert( module.willFileArray.length === 0, 'not tested' );
  _.assert( !module.willFilesFindReady.resourcesCount() );
  _.assert( !module.willFilesOpenReady.resourcesCount() );
  _.assert( !module.submodulesFormReady.resourcesCount() );
  _.assert( !module.resourcesFormReady.resourcesCount() );

  /* specific terminal file */

  if( module.filePath && fileProvider.resolvedIsTerminal( module.filePath ) )
  {

    _.assert( module.willFileWithRoleMap.single === undefined )

    new will.WillFile
    ({
      role : 'single',
      filePath : module.filePath,
      module : module,
    }).form1();

    let willf = module.willFileWithRoleMap.single;

    if( willf.exists() )
    {
      filePaths = [ module.filePath ];
      namedNameDeduce();
      return end( filePaths );
    }
    else
    {
      debugger;
      willf.finit();
    }

  }

  /* */

  let roles = [ 'single', 'import', 'export' ];
  let files = Object.create( null );

  // debugger; // yyy

  /* */

  for( let r = 0 ; r < roles.length ; r++ )
  {
    let role = roles[ r ];
    files[ role ] = module._willFileFindMaybe
    ({
      role : role,
      isOutFile : o.isOutFile,
      isNamed : 1,
    })
  }

  filePaths = filePathsGet( files );
  if( filePaths.length )
  {
    namedNameDeduce();
    return end( filePaths );
  }

  /* */

  for( let r = 0 ; r < roles.length ; r++ )
  {
    let role = roles[ r ];
    files[ role ] = module._willFileFindMaybe
    ({
      role : role,
      isOutFile : o.isOutFile,
      isNamed : 0,
    })
  }

  filePaths = filePathsGet( files );
  if( filePaths.length )
  {
    notNamedNameDeduce();
    return end( filePaths );
  }

  /* */

  for( let r = 0 ; r < roles.length ; r++ )
  {
    let role = roles[ r ];
    files[ role ] = module._willFileFindMaybe
    ({
      role : role,
      isOutFile : !o.isOutFile,
      isNamed : 1,
    })
  }

  filePaths = filePathsGet( files );
  if( filePaths.length )
  {
    namedNameDeduce();
    return end( filePaths );
  }

  /* */

  for( let r = 0 ; r < roles.length ; r++ )
  {
    let role = roles[ r ];
    files[ role ] = module._willFileFindMaybe
    ({
      role : role,
      isOutFile : !o.isOutFile,
      isNamed : 0,
    })
  }

  filePaths = filePathsGet( files );
  if( filePaths.length )
  {
    notNamedNameDeduce();
    return end( filePaths );
  }

  // debugger;
  return null;

  /* */

  function namedNameDeduce()
  {
    for( let w = 0 ; w < module.willFileArray.length ; w++ )
    {
      let willFile = module.willFileArray[ w ];
      let name = path.name( willFile.filePath );
      name = _.strRemoveEnd( name, '.will' );
      name = _.strRemoveEnd( name, '.im' );
      name = _.strRemoveEnd( name, '.ex' );
      _.assert( module.configName === null || module.configName === name, 'Name of will files should be the same, something wrong' );
      if( name )
      module.configName = name;
    }
  }

  /* */

  function notNamedNameDeduce()
  {
    module.configName = path.fullName( path.dir( filePaths[ 0 ] ) );
  }

  /* - */

  function filePathsGet()
  {
    let filePaths = [];
    if( files.single )
    filePaths.push( files.single.filePath );
    if( files.import )
    filePaths.push( files.import.filePath );
    if( files.export )
    filePaths.push( files.export.filePath );
    return filePaths;
  }

  /* */

  function end( filePaths )
  {
    let filePath = module.DirPathFromFilePaths( filePaths );
    module.filePathChange( filePath, path.dir( filePath ) );
    return true;
  }

}

_willFilesFindMaybe.defaults =
{
  isOutFile : 0,
}

//

function willFilesFind()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  module.willFilesReadBegin();

  if( module.willFilesFound > 0 )
  return module.stager.stageConsequence( 'willFilesFound' );
  module.stager.stageState( 'willFilesFound', 1 );

  return module.stager.stageConsequence( 'willFilesFound', -1 ).split()
  .thenKeep( () =>
  {
    module.stager.stageState( 'willFilesFound', 2 );

    let result = module._willFilesFindMaybe({ isOutFile : !!module.supermodule });

    if( !result )
    {
      if( module.supermodule )
      throw _.errBriefly( 'Found no .out.will file for',  module.supermodule.nickName, 'at', _.strQuote( module.filePath || module.dirPath ) );
      else
      throw _.errBriefly( 'Found no will-file at', _.strQuote( module.filePath || module.dirPath ) );
    }

    result = _.Consequence.From( result );
    _.assert( _.consequenceIs( result ) );

    result.finally( function( err, arg )
    {
      if( !err && module.willFileArray.length === 0 )
      throw _.errLogOnce( 'No will files', module.nickName, 'at', _.strQuote( module.dirPath ) );
      if( err )
      throw _.errLogOnce( 'Error looking for will files for', module.nickName, 'at', _.strQuote( module.dirPath ), '\n', err );
      return arg;
    });

    return result;
  })
  .finallyKeep( function( err, arg )
  {
    if( err )
    throw module.stager.stageError( 'willFilesFound', err );
    else
    module.stager.stageState( 'willFilesFound', 3 );
    return arg;
  });

}

willFilesFind.defaults = Object.create( _willFilesFindMaybe.defaults );

//

function willFilesOpen()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  /* */

  if( module.willFilesOpened > 0 )
  return module.stager.stageConsequence( 'willFilesOpened' );
  module.stager.stageState( 'willFilesOpened', 1 );

  /* */

  return module.stager.stageConsequence( 'willFilesOpened', -1 ).split()
  .keep( ( arg ) =>
  {
    module.stager.stageState( 'willFilesOpened', 2 );
    return module._willFilesOpen();
  })
  .finally( ( err, arg ) =>
  {

    if( err )
    throw module.stager.stageError( 'willFilesOpened', err );
    else
    module.stager.stageState( 'willFilesOpened', 3 );

    return arg;
  });
}

//

function _willFilesOpen()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let con = new _.Consequence().take( null );
  let time = _.timeNow();

  _.assert( arguments.length === 0 );
  _.sure( !!_.mapKeys( module.willFileWithRoleMap ).length && !!module.willFileArray.length, () => 'Found no will file at ' + _.strQuote( module.dirPath ) );

  /* */

  for( let i = 0 ; i < module.willFileArray.length ; i++ )
  {
    let willFile = module.willFileArray[ i ];

    _.assert( willFile.formed === 1 || willFile.formed === 2, 'not expected' );

    if( willFile.formed === 2 )
    continue;

    con.keep( ( arg ) => willFile.open() );

  }

  /* */

  con.finally( ( err, arg ) =>
  {
    if( !module.supermodule )
    {
      if( !err )
      {
        let total = module.willFileArray.length;
        let opened = _.mapVals( module.submoduleMap );
        //
        // for( let i = 0 ; i < opened.length ; i++ )
        // if( opened[ i ].loadedModule )
        // total += opened[ i ].loadedModule.willFileArray.length;
        //
        // if( will.verbosity >= 2 )
        // logger.log( ' . Read', total, 'will-files in', _.timeSpent( time ) );
        //
      }
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  return con.split();
}

//

function _willFilesCacheOpen()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let con = new _.Consequence().take( null );
  let time = _.timeNow();

  _.assert( arguments.length === 0 );
  _.sure( !!_.mapKeys( module.willFileWithRoleMap ).length && !!module.willFileArray.length, () => 'Found no will file at ' + _.strQuote( module.dirPath ) );

  xxx

  return con.split();
}

//

function _willFilesCacheSave()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = Object.create( null );

  if( !module.about || !module.about.name )
  return null;

  _.assert( arguments.length === 0 );
  _.assert( _.strIs( module.about.name ) );

  result.format = 'willstate-1.0.0';
  result.time = _.timeNow();
  result.willFiles = module._willFilesExport();

  // debugger;
  let filePath = module.dirPath + '/' + ( module.configName || '' ) + '.will.state.json';
  // debugger;
  // fileProvider.fileWrite({ filePath : filePath, data : result, encoding : 'json.min' });

  return result;
}

//

function willFilesReadBegin()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  module.willFilesReadBeginTime = _.timeNow();

}

//

function willFilesReadEnd()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  if( will.verbosity >= 2 )
  if( !module.supermodule )
  logger.log( ' . Read', module.willFilesSelect().length, 'will-files in', _.timeSpent( module.willFilesReadBeginTime ), '\n' );

}

//

function _willFilesExport()
{
  let module = this;
  let will = module.will;
  let result = Object.create( null );

  module.willFileEach( handeWillFile );

  return result;

  function handeWillFile( willFile )
  {
    _.assert( _.objectIs( willFile.data ) );
    result[ willFile.filePath ] = willFile.data;
  }
}

//

function willFileEach( onEach )
{
  let module = this;
  let will = module.will;

  for( let w = 0 ; w < module.willFileArray.length ; w++ )
  {
    let willFile = module.willFileArray[ w ];
    onEach( willFile )
  }

  for( let s in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ s ];
    if( !submodule.loadedModule )
    continue;

    for( let w = 0 ; w < submodule.loadedModule.willFileArray.length ; w++ )
    {
      let willFile = submodule.loadedModule.willFileArray[ w ];
      onEach( willFile )
    }

  }

}

// --
// submodule
// --

function submodulesAllAreDownloaded()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( !module.supermodule );

  for( let n in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ n ].loadedModule;
    if( !submodule )
    return false;
    if( !submodule.isDownloaded )
    return false;
  }

  return true;
}

//

function submodulesHaveAnyError()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( !module.supermodule );

  for( let n in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ n ].loadedModule;
    if( !submodule )
    continue;
    // debugger;
    // if( submodule.errors.length )
    // return false;
    if( submodule.hasAnyError() )
    return true;
  }

  return false;
}

//

function _submodulesDownload( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let downloadedNumber = 0;
  let remoteNumber = 0;
  let totalNumber = _.mapKeys( module.submoduleMap ).length;
  let time = _.timeNow();
  let con = new _.Consequence().take( null );

  _.assert( module.preformed === 3 );
  _.assert( arguments.length === 1 );
  _.routineOptions( _submodulesDownload, arguments );

  logger.up();

  for( let n in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ n ].loadedModule;
    // debugger;
    _.assert( !!submodule && submodule.preformed === 3, 'Submodule', ( submodule ? submodule.nickName : n ), 'was not preformed' );

    if( !submodule.isRemote )
    continue;

    con.keep( () =>
    {

      remoteNumber += 1;

      let r = _.Consequence.From( submodule._remoteDownload( _.mapExtend( null, o ) ) );
      return r.keep( ( arg ) =>
      {

        _.assert( _.boolIs( arg ) );
        if( arg )
        downloadedNumber += 1;

        return arg;
      });
    });

  }

  con.finally( ( err, arg ) =>
  {
    logger.down();
    if( err )
    throw _.err( 'Failed to', ( o.upgrading ? 'upgrade' : 'download' ), 'submodules of', module.nickName, '\n', err );
    logger.rbegin({ verbosity : -2 });
    logger.log( ' + ' + downloadedNumber + /*'/' + remoteNumber +*/ '/' + totalNumber + ' submodule(s) of ' + module.nickName + ' were ' + ( o.upgrading ? 'upgraded' : 'downloaded' ) + ' in ' + _.timeSpent( time ) );
    logger.rend({ verbosity : -2 });
    return arg;
  });

  return con;
}

_submodulesDownload.defaults =
{
  upgrading : 0,
  forming : 1,
}

//

function submodulesDownload()
{
  let module = this;
  let will = module.will;

  _.assert( module.preformed === 3 );
  _.assert( arguments.length === 0 );

  return module._submodulesDownload({ upgrading : 0 });
}

//

function submodulesUpgrade()
{
  let module = this;
  let will = module.will;

  _.assert( module.preformed === 3 );
  _.assert( arguments.length === 0 );

  return module._submodulesDownload({ upgrading : 1 });
}

//

function submodulesClean()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  _.assert( module.preformed === 3 );
  _.assert( arguments.length === 0 );

  let result = module.clean
  ({
    cleaningSubmodules : 1,
    cleaningOut : 0,
    cleaningTemp : 0,
  });

  return result;
}

//

function submodulesFormSkip()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  if( module.submodulesFormed > 0 )
  return module.stager.stageConsequence( 'submodulesFormed' );

  return module.stager.stageSkip( 'submodulesFormed' );

  // if( module.submodulesFormed > 0 )
  // return module.stager.stageConsequence( 'submodulesFormed' );
  // module.stager.stageState( 'submodulesFormed', 1 );
  //
  // return module.stager.stageConsequence( 'submodulesFormed', -1 ).split()
  // .finally( ( err, arg ) =>
  // {
  //
  //   module.stager.stageState( 'submodulesFormed', 2 );
  //
  //   if( err )
  //   throw module.stager.stageError( 'submodulesFormed', err );
  //   else
  //   module.stager.stageState( 'submodulesFormed', 3 );
  //
  //   return arg;
  // });

}

//

function submodulesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  if( module.submodulesFormed > 0 )
  return module.stager.stageConsequence( 'submodulesFormed' );
  module.stager.stageState( 'submodulesFormed', 1 );

  return module.stager.stageConsequence( 'submodulesFormed', -1 ).split()
  .keep( ( arg ) =>
  {
    module.stager.stageState( 'submodulesFormed', 2 );
    return module._submodulesForm();
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    throw module.stager.stageError( 'submodulesFormed', err );
    else
    module.stager.stageState( 'submodulesFormed', 3 );
    return arg;
  });
}

//

function _submodulesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  module._resourcesFormAct( will.Submodule, con );

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con.split();
}

//

function submodulesReload()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  return module.ready
  .then( function( arg )
  {
    // debugger;
    // this.take( err, arg );
    return module._submodulesForm();
    // return arg;
  })
  .split();

}

// --
// remote
// --

function remoteIsRemote()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  let fileProvider2 = fileProvider.providerForPath( module.filePath );
  if( fileProvider2.limitedImplementation )
  return end( true );

  return end( false );

  /* */

  function end( result )
  {
    module.isRemote = result;
    return result;
  }
}

//

function remoteIsDownloaded()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( _.strDefined( module.clonePath ) );
  _.assert( _.strDefined( module.filePath ) );
  _.assert( module.isRemote === true );

  let fileProvider2 = fileProvider.providerForPath( module.remotePath );
  _.assert( !!fileProvider2.limitedImplementation );

  let result = fileProvider2.isDownloaded
  ({
    remotePath : module.remotePath,
    localPath : module.clonePath,
  });

  if( !result )
  return end( result );

  return _.Consequence.From( result )
  .finally( ( err, arg ) =>
  {
    end( arg );
    if( err )
    throw err;
    return arg;
  });

  /* */

  function end( result )
  {
    module.isDownloaded = !!result;
    return result;
  }
}

//

function remoteIsUpToDate()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( _.strDefined( module.clonePath ) );
  _.assert( _.strDefined( module.filePath ) );
  _.assert( module.isRemote === true );

  let fileProvider2 = fileProvider.providerForPath( module.remotePath );

  _.assert( !!fileProvider2.limitedImplementation );

  let result = fileProvider2.isUpToDate
  ({
    remotePath : module.remotePath,
    localPath : module.clonePath,
    verbosity : will.verbosity - 3,
  });

  if( !result )
  return end( result );

  return _.Consequence.From( result )
  .finally( ( err, arg ) =>
  {
    end( arg );
    if( err )
    throw err;
    return arg;
  });

  /* */

  function end( result )
  {
    module.isUpToDate = !!result;
    return result;
  }
}

//

function remoteForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( module.preformed === 2 );
  _.assert( _.strDefined( module.filePath ) );

  module.isRemote = module.remoteIsRemote();

  if( module.isRemote )
  {
    module.remoteFormAct();
  }
  else
  {
    module.isDownloaded = 1;
  }

  return module;
}

//

function remoteFormAct()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( module.preformed === 2 );
  _.assert( _.strDefined( module.filePath ) );
  _.assert( _.strDefined( module.alias ) );
  _.assert( !!module.supermodule );

  let fileProvider2 = fileProvider.providerForPath( module.filePath );
  let submodulesDir = module.supermodule.submodulesCloneDirGet();
  let localPath = fileProvider2.pathIsolateGlobalAndLocal( module.filePath )[ 1 ];

  // debugger;
  module.remotePath = module.filePath;
  module.clonePath = path.resolve( submodulesDir, module.alias );
  module.dirPath = path.resolve( module.clonePath, localPath );
  module.filePath = module.dirPath;
  module.isDownloaded = !!module.remoteIsDownloaded();

  _.assert( will.moduleMap[ module.id ] === module );
  // _.assert( will.moduleMap[ module.filePath ] === module );
  // _.assert( will.moduleMap[ module.remotePath ] === module ); // yyy
  // _.sure( will.moduleMap[ module.filePath ] === undefined, () => 'Module at ' + _.strQuote( module.dirPath ) + ' already exists' ); // yyy
  // will.moduleMap[ module.dirPath ] = module;

  return module;
}

//

function _remoteDownload( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let time = _.timeNow();
  let wasUpToDate = false;
  let con = _.Consequence().take( null );

  _.routineOptions( _remoteDownload, o );
  _.assert( arguments.length === 1 );
  _.assert( module.preformed === 3 );
  _.assert( _.strDefined( module.filePath ) );
  _.assert( _.strDefined( module.alias ) );
  _.assert( _.strDefined( module.remotePath ) );
  _.assert( _.strDefined( module.clonePath ) );
  _.assert( !!module.supermodule );

  if( !o.upgrading )
  {
    // possible fix of submodules.download problem:
    // module.isDownloaded = !!module.remoteIsDownloaded();

    if( module.isDownloaded )
    return false;
  }

  let o2 =
  {
    reflectMap : { [ module.remotePath ] : module.clonePath },
    verbosity : will.verbosity - 5,
    extra : { fetching : 0 },
  }

  return con
  .keep( () => module.remoteIsUpToDate() )
  .keep( function( arg )
  {
    wasUpToDate = module.isUpToDate;
    /*
    delete downloaded module if it has critical error
    */
    if( module.willFilesOpenReady.errorsCount() )
    fileProvider.filesDelete({ filePath : module.clonePath, throwing : 0, sync : 1 });
    return arg;
  })
  .keep( () => will.Predefined.filesReflect.call( fileProvider, o2 ) )
  .keep( function( arg )
  {
    module.isUpToDate = true;
    module.isDownloaded = true;
    if( o.forming && 1 )
    {
      _.assert( module.preformed === 3, 'not tested' );

      // debugger;
      if( module.resourcesFormReady.errorsCount() || module.ready.errorsCount() )
      module.stateResetError();

      module.willFilesFind();
      module.willFilesOpen();
      module.submodulesFormSkip();
      module.resourcesFormSkip();
      // debugger;

      return module.ready
      .finallyGive( function( err, arg )
      {
        this.take( err, arg );
      })
      .split();
    }
    return null;
  })
  .finallyKeep( function( err, arg )
  {
    if( err )
    throw _.err( 'Failed to', ( o.upgrading ? 'upgrade' : 'download' ), module.nickName, '\n', err );
    if( will.verbosity >= 3 && !wasUpToDate )
    logger.log( ' + ' + module.nickName + ' was ' + ( o.upgrading ? 'upgraded' : 'downloaded' ) + ' in ' + _.timeSpent( time ) );
    return !wasUpToDate;
  });

}

_remoteDownload.defaults =
{
  upgrading : 0,
  forming : 1,
}

//

function remoteDownload()
{
  let module = this;
  let will = module.will;
  return module._remoteDownload({ upgrading : 0 });
}

//

function remoteUpgrade()
{
  let module = this;
  let will = module.will;
  return module._remoteDownload({ upgrading : 1 });
}

// --
// resource
// --

function resourcesFormSkip()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  if( module.resourcesFormed > 0 )
  return module.stager.stageConsequence( 'resourcesFormed' );

  return module.stager.stageSkip( 'resourcesFormed' )
  .tap( ( err, arg ) =>
  {

    module.willFilesReadEnd();

    _.assert( !module.ready.resourcesCount() );
    module.ready.takeSoon( err, arg );
    _.assert( !module.ready.resourcesCount() );
  });

}

//

function resourcesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  if( module.resourcesFormed > 0 )
  return module.stager.stageConsequence( 'resourcesFormed' );
  module.stager.stageState( 'resourcesFormed', 1 );

  return module.stager.stageConsequence( 'resourcesFormed', -1 ).split()
  .keep( ( arg ) =>
  {

    let con = new _.Consequence().take( null );

    module.stager.stageState( 'resourcesFormed', 2 );

    if( !module.supermodule )
    if( module.submodulesAllAreDownloaded() && !module.submodulesHaveAnyError() )
    {

      con.keep( () => module._resourcesForm() );

      con.keep( ( arg ) =>
      {
        if( !module.supermodule )
        module._willFilesCacheSave();
        return arg;
      });

    }
    else
    {
      if( will.verbosity === 2 )
      logger.error( ' ! One or more submodules of ' + module.nickName + ' were not downloaded!'  );
    }

    return con;
  })
  .finally( ( err, arg ) =>
  {

    module.willFilesReadEnd();

    _.assert( !module.ready.resourcesCount() );
    module.ready.takeSoon( err, arg );
    _.assert( !module.ready.resourcesCount() );

    if( err )
    throw module.stager.stageError( 'resourcesFormed', err );
    else
    module.stager.stageState( 'resourcesFormed', 3 );

    return arg;
  });

}

//

function _resourcesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  /* */

  module._resourcesFormAct( will.Submodule, con );
  module._resourcesFormAct( will.Exported, con );
  module._resourcesFormAct( will.PathResource, con );
  module._resourcesFormAct( will.Reflector, con );
  module._resourcesFormAct( will.Step, con );
  module._resourcesFormAct( will.Build, con );

  /* */

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con.split();
}

//

function _resourcesFormAct( Resource, con )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( _.constructorIs( Resource ) );
  _.assert( arguments.length === 2 );

  // if( Resource.KindName === 'submodule' )
  // debugger;

  for( let s in module[ Resource.MapName ] )
  {
    let resource = module[ Resource.MapName ][ s ];
    _.assert( !!resource.formed );
    con.keep( ( arg ) => resource.form2() );
  }

  for( let s in module[ Resource.MapName ] )
  {
    let resource = module[ Resource.MapName ][ s ];
    con.keep( ( arg ) => resource.form3() );
  }

}

//

function resourceClassForKind( resourceKind )
{
  let module = this;
  let will = module.will;
  let result = will[ will.ResourceKindToClassName.forKey( resourceKind ) ];

  _.assert( arguments.length === 1 );
  _.sure( _.routineIs( result ), () => 'Cant find class for resource kind ' + _.strQuote( resourceKind ) );

  return result;
}

//

function resourceMapForKind( resourceKind )
{
  let module = this;
  let will = module.will;
  let result;

  if( resourceKind === 'export' )
  result = module.buildMap;
  else
  result = module[ will.ResourceKindToMapName.forKey( resourceKind ) ];

  _.assert( arguments.length === 1 );
  _.sure( _.objectIs( result ), () => 'Cant find resource map for resource kind ' + _.strQuote( resourceKind ) );

  return result;
}

//

function resourceObtain( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceName ) );

  let resource = module.resolve
  ({
    selector : resourceKind + '::' + resourceName,
    pathResolving : 0,
    pathUnwrapping : 0,
    missingAction : 'undefine',
  });

  if( !resource )
  resource = module.resourceAllocate( resourceKind, resourceName );

  _.assert( resource instanceof will.Resource );
  if( resource instanceof will.PathResource )
  _.assert( module.pathResourceMap[ resource.name ] === resource );

  return resource;
}

//

function resourceAllocate( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceName ) );

  let resourceName2 = module.resourceNameAllocate( resourceKind, resourceName );
  let cls = module.resourceClassForKind( resourceKind );
  let resource = new cls({ module : module, name : resourceName2 }).form1();

  return resource;
}

//

function resourceNameAllocate( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceKind ) );
  _.assert( _.strIs( resourceName ) );

  let map = module.resourceMapForKind( resourceKind );

  if( map[ resourceName ] === undefined )
  return resourceName;

  let counter = 1;
  let resourceName2;

  let ends = /\.\d+$/;
  if( ends.test( resourceName ) )
  resourceName = resourceName.replace( ends, '' );

  do
  {
    resourceName2 = resourceName + '.' + counter;
    counter += 1;
  }
  while( map[ resourceName2 ] !== undefined );

  return resourceName2;
}

// --
// path
// --

function submodulesCloneDirGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  _.assert( arguments.length === 0 );
  return path.join( module.dirPath, '.module' );
}

//

function filePathChange( filePath, dirPath )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  filePath = path.normalizeTolerant( filePath );
  dirPath = path.normalize( dirPath );

  _.assert( arguments.length === 2 );
  _.assert( module.preformed === 3 );
  _.assert( will.moduleMap[ module.id ] === module );

  module._filePathChange( filePath, dirPath );

  return module;
}

//

function _filePathChange( filePath, dirPath )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( filePath )
  filePath = path.normalizeTolerant( filePath );
  if( dirPath )
  dirPath = path.normalize( dirPath );

  _.assert( arguments.length === 2 );
  _.assert( dirPath === null || _.strDefined( dirPath ) );
  _.assert( dirPath === null || path.isAbsolute( dirPath ) );
  _.assert( dirPath === null || path.isNormalized( dirPath ) );
  _.assert( _.strDefined( filePath ) );
  _.assert( path.isAbsolute( filePath ) );

  module.dirPath = dirPath;
  module.filePath = filePath;

  return module;
}

//

function inPathGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  return path.s.resolve( module.dirPath, ( module.pathMap.in || '.' ) );
}

//

function outPathGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  return path.s.resolve( module.dirPath, ( module.pathMap.in || '.' ), ( module.pathMap.out || '.' ) );
}

//

function nonExportablePathGet_functor( name )
{

  // let symbol = Symbol.for( name );

  return function nonExportablePathGet()
  {
    let module = this;

    if( !module.will)
    return null;

    // if( !module.pathResourceMap[ name ] )
    // {
    //   let resource = new _.Will.PathResource({ module : module, name : name }).form1();
    //   resource.criterion = resource.criterion || Object.create( null );
    //   resource.criterion.predefined = 1;
    //   resource.writable = 0;
    // }

    return module.pathMap[ name ] || null;
  }

}

//

function nonExportablePathSet_functor( name )
{

  // let symbol = Symbol.for( name );

  return function nonExportablePathSet( filePath )
  {
    let module = this;

    // module[ symbol ] = filePath;

    if( !module.will && !filePath )
    return filePath;

    // if( name === 'dirPath' )
    // debugger;

    if( !module.pathResourceMap[ name ] )
    {
      let resource = new _.Will.PathResource({ module : module, name : name }).form1();
      resource.criterion = resource.criterion || Object.create( null );
      resource.criterion.predefined = 1;
      resource.writable = 0;
    }

    _.assert( !!module.pathResourceMap[ name ] );
    _.assert( !module.pathResourceMap[ name ].writable, 'Path ' + name + ' is non-writable' );
    _.assert( module.pathResourceMap[ name ].criterion.predefined, 'Path ' + name + ' is predefined' );

    module.pathResourceMap[ name ].path = filePath;

    return filePath;
  }

}

let filePathGet = nonExportablePathGet_functor( 'filePath' );
let dirPathGet = nonExportablePathGet_functor( 'dirPath' );
let clonePathGet = nonExportablePathGet_functor( 'clonePath' );
let remotePathGet = nonExportablePathGet_functor( 'remotePath' );
let willPathGet = nonExportablePathGet_functor( 'willPath' );

let filePathSet = nonExportablePathSet_functor( 'filePath' );
let dirPathSet = nonExportablePathSet_functor( 'dirPath' );
let clonePathSet = nonExportablePathSet_functor( 'clonePath' );
let remotePathSet = nonExportablePathSet_functor( 'remotePath' );

// //
//
// function filePathSet( filePath )
// {
//   let module = this;
//   module[ filePathSymbol ] = filePath;
//
//   if( !module.will && !filePath )
//   return filePath;
//
//   if( !module.pathResourceMap.filePath )
//   {
//     debugger;
//     // let resource = module.resourceAllocate( 'path', 'filePath' );
//     let resource = new _.Will.PathResource({ module : module, name : 'filePath' }).form1();
//     debugger;
//     resource.readOnly = true;
//   }
//
//   _.assert( !!module.pathResourceMap.filePath );
//   _.assert( module.pathResourceMap.filePath.readOnly, 'Path filePath is read only' );
//
//   if( module.pathMap )
//   {
//     // _.assert( module.pathMap.filePath === undefined || module.pathMap.filePath === null || module.pathMap.filePath === filePath );
//     // _.assert( module.pathResourceMap.filePath === undefined, 'Path filePath is read only' );
//     // module.pathMap.filePath = filePath;
//     module.pathResourceMap.filePath.path = filePath;
//   }
//
//   return filePath;
// }
//
// //
//
// function dirPathSet( dirPath )
// {
//   let module = this;
//   module[ dirPathSymbol ] = dirPath;
//
//   if( !module.will && !filePath )
//   return dirPath;
//
//   if( !module.pathResourceMap.dirPath )
//   {
//     // let resource = module.resourceAllocate( 'path', 'dirPath' );
//     let resource = new _.Will.PathResource({ module : module, name : 'dirPath' }).form1();
//     resource.readOnly = true;
//   }
//
//   _.assert( !!module.pathResourceMap.dirPath );
//   _.assert( module.pathResourceMap.dirPath.readOnly, 'Path dirPath is read only' );
//
//   if( module.pathMap )
//   {
//     // _.assert( module.pathMap.dirPath === undefined || module.pathMap.dirPath === null || module.pathMap.dirPath === dirPath );
//     // _.assert( module.pathResourceMap.dirPath === undefined, 'Path dirPath is read only' );
//     // module.pathMap.dirPath = dirPath;
//     module.pathResourceMap.dirPath.path = dirPath;
//   }
//
//   return dirPath;
// }
//
//
// //
//
// function clonePathSet( clonePath )
// {
//   let module = this;
//   module[ clonePathSymbol ] = clonePath;
//
//   if( !module.will && !filePath )
//   return clonePath;
//
//   if( !module.pathResourceMap.clonePath )
//   {
//     // let resource = module.resourceAllocate( 'path', 'clonePath' );
//     let resource = new _.Will.PathResource({ module : module, name : 'clonePath' }).form1();
//     resource.readOnly = true;
//   }
//
//   _.assert( !!module.pathResourceMap.clonePath );
//   _.assert( module.pathResourceMap.clonePath.readOnly, 'Path clonePath is read only' );
//
//   if( module.pathMap )
//   {
//     // _.assert( module.pathMap.clonePath === undefined || module.pathMap.clonePath === null || module.pathMap.clonePath === clonePath );
//     // _.assert( module.pathResourceMap.clonePath === undefined, 'Path clonePath is read only' );
//     // module.pathMap.clonePath = clonePath;
//     module.pathResourceMap.clonePath.path = clonePath;
//   }
//
//   return clonePath;
// }
//
//
// //
//
// function remotePathSet( remotePath )
// {
//   let module = this;
//   module[ remotePathSymbol ] = remotePath;
//
//   if( !module.pathResourceMap.remotePath )
//   {
//     // let resource = module.resourceAllocate( 'path', 'remotePath' );
//     let resource = new _.Will.PathResource({ module : module, name : 'remotePath' }).form1();
//     resource.readOnly = true;
//   }
//
//   _.assert( !!module.pathResourceMap.remotePath );
//   _.assert( module.pathResourceMap.remotePath.readOnly, 'Path remotePath is read only' );
//
//   if( module.pathMap )
//   {
//     // _.assert( module.pathMap.remotePath === undefined || module.pathMap.remotePath === null || module.pathMap.remotePath === remotePath );
//     // _.assert( module.pathResourceMap.remotePath === undefined, 'Path remotePath is read only' );
//     // module.pathMap.remotePath = remotePath;
//     module.pathResourceMap.remotePath.path = remotePath;
//   }
//
//   return remotePath;
// }

// --
// accessor
// --

function _nickNameGet()
{
  let module = this;
  let name = module.alias ? module.alias : null;
  if( !name && module.about )
  name = module.about.name;
  if( !name )
  name = module.dirPath;
  return 'module' + '::' + name;
  // return module.constructor.shortName + '::' + name;
  // return '→ ' + module.constructor.shortName + ' ' + _.strQuote( name ) + ' ←';
}

//

function _absoluteNameGet()
{
  let module = this;
  let supermodule = module.supermodule;
  if( supermodule )
  return supermodule.nickName + ' / ' + module.nickName;
  else
  return module.nickName;
}

// --
// selector
// --

/*
iii : implement name glob filtering
*/

function _buildsSelect_pre( routine, args )
{
  let module = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length <= 2 );

  let o;
  if( args[ 1 ] !== undefined )
  o = { name : args[ 0 ], criterion : args[ 1 ] }
  else
  o = args[ 0 ];

  o = _.routineOptions( routine, o );
  _.assert( _.arrayHas( [ 'build', 'export' ], o.resource ) );
  _.assert( _.arrayHas( [ 'default', 'more' ], o.preffering ) );
  _.assert( o.criterion === null || _.routineIs( o.criterion ) || _.mapIs( o.criterion ) );

  if( o.preffering === 'default' )
  o.preffering = 'default';

  return o;
}

//

function _buildsSelect_body( o )
{
  let module = this;
  let elements = module.buildMap;

  _.assertRoutineOptions( _buildsSelect_body, arguments );
  _.assert( arguments.length === 1 );

  if( o.name )
  {
    elements = _.mapVals( _.path.globFilterKeys( elements, o.name ) );
    if( !elements.length )
    return []
    if( o.criterion === null || Object.keys( o.criterion ).length === 0 )
    return elements;
  }
  else
  {
    elements = _.mapVals( elements );
  }

  let hasMapFilter = _.objectIs( o.criterion ) && Object.keys( o.criterion ).length > 0;
  if( _.routineIs( o.criterion ) || hasMapFilter )
  {

    _.assert( _.objectIs( o.criterion ), 'not tested' );

    elements = filterWith( elements, o.criterion );

  }
  else if( _.objectIs( o.criterion ) && Object.keys( o.criterion ).length === 0 && !o.name && o.preffering === 'default' )
  {

    elements = filterWith( elements, { default : 1 } );

  }

  if( o.resource === 'export' )
  elements = elements.filter( ( element ) => element.criterion && element.criterion.export );
  else if( o.resource === 'build' )
  elements = elements.filter( ( element ) => !element.criterion || !element.criterion.export );

  return elements;

  /* */

  function filterWith( elements, filter )
  {

    _.assert( _.objectIs( filter ), 'not tested' );

    if( _.objectIs( filter ) && Object.keys( filter ).length > 0 )
    {

      let template = filter;
      filter = function filter( build, k, c )
      {
        if( build.criterion === null && Object.keys( template ).length )
        return;

        let satisfied = _.mapSatisfy
        ({
          template : template,
          src : build.criterion,
          levels : 1,
        });

        if( satisfied )
        return build;
      }

    }

    elements = _.entityFilter( elements, filter );

    return elements;
  }

}

_buildsSelect_body.defaults =
{
  resource : null,
  name : null,
  criterion : null,
  preffering : 'default',
}

let _buildsSelect = _.routineFromPreAndBody( _buildsSelect_pre, _buildsSelect_body );

//

let buildsSelect = _.routineFromPreAndBody( _buildsSelect_pre, _buildsSelect_body );
var defaults = buildsSelect.defaults;
defaults.resource = 'build';

//

let exportsSelect = _.routineFromPreAndBody( _buildsSelect_pre, _buildsSelect_body );
var defaults = exportsSelect.defaults;
defaults.resource = 'export';

//

function willFilesSelect()
{
  let module = this;
  let will = module.will;
  _.assert( arguments.length === 0 );

  let result = module.willFileArray.slice();

  for( let m in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ m ].loadedModule;
    if( !submodule )
    continue;
    _.arrayAppendArrayOnce( result, submodule.willFilesSelect() );
  }

  return result;
}

// --
// resolver
// --

function errResolving( o )
{
  let module = this;
  _.routineOptions( errResolving, arguments );
  if( o.current && o.current.nickName )
  return _.err( 'Failed to resolve', _.strQuote( o.selector ), 'for', o.current.nickName, 'in', module.nickName, '\n', o.err );
  else
  return _.err( 'Failed to resolve', _.strQuote( o.selector ), 'in', module.nickName, '\n', o.err );
}

errResolving.defaults =
{
  err : null,
  current : null,
  selector : null,
}

//

function _selectorShortSplitAct( selector )
{
  let module = this;
  _.assert( !_.strHas( selector, '/' ) );
  let result = _.strIsolateLeftOrNone( selector, '::' );
  return result;
}

//

function _selectorShortSplit( o )
{
  let module = this;
  let will = module.will;
  let result;

  _.assertRoutineOptions( _selectorShortSplit, o );
  _.assert( arguments.length === 1 );
  _.assert( !_.strHas( o.selector, '/' ) );
  _.sure( _.strIs( o.selector ), 'Expects string, but got', _.strType( o.selector ) );

  let splits = module._selectorShortSplitAct( o.selector );

  if( !splits[ 0 ] && o.defaultResourceName )
  {
    splits = [ o.defaultResourceName, '::', o.selector ]
  }

  return splits;
}

var defaults = _selectorShortSplit.defaults = Object.create( null )
defaults.selector = null
defaults.defaultResourceName = null;

//

function selectorLongSplit( o )
{
  let module = this;
  let will = module.will;
  let result = [];

  if( _.strIs( o ) )
  o = { selector : o }

  _.routineOptions( selectorLongSplit, o );
  _.assert( arguments.length === 1 );
  _.sure( _.strIs( o.selector ), 'Expects string, but got', _.strType( o.selector ) );

  let selectors = o.selector.split( '/' );

  selectors.forEach( ( selector ) =>
  {
    let o2 = _.mapExtend( null, o );
    o2.selector = selector;
    result.push( module._selectorShortSplit( o2 ) );
  });

  return result;
}

var defaults = selectorLongSplit.defaults = Object.create( null )
defaults.selector = null
defaults.defaultResourceName = null;

//

function selectorParse( o )
{
  let module = this;
  let will = module.will;
  let result = [];

  if( _.strIs( o ) )
  o = { selector : o }

  _.routineOptions( selectorParse, o );
  _.assert( arguments.length === 1 );
  _.sure( _.strIs( o.selector ), 'Expects string, but got', _.strType( o.selector ) );

  let splits = _.strSplitFast
  ({
    src : o.selector,
    delimeter : [ '{', '}' ],
  });

  splits = _.strSplitsCoupledGroup({ splits : splits, prefix : '{', postfix : '}' });

  if( splits[ 0 ] === '' )
  splits.splice( 0, 1 );
  if( splits[ splits.length-1 ] === '' )
  splits.splice( splits.length-1, 1 );

  splits = splits.map( ( split ) =>
  {
    if( !_.arrayIs( split ) )
    return split;
    _.assert( split.length === 3 )
    if( module.SelectorIs( split[ 1 ] ) )
    {
      let o2 = _.mapExtend( null, o );
      o2.selector = split[ 1 ];
      split[ 1 ] = module.selectorLongSplit( o2 );
    }
    return split;
  });

  return splits;
}

var defaults = selectorParse.defaults = Object.create( null )
defaults.selector = null
defaults.defaultResourceName = null;

//

function SelectorIs( selector )
{
  if( !_.strIs( selector ) )
  return false;
  if( !_.strHas( selector, '::' ) )
  return false;
  return true;
}

//

function SelectorIsComposite( selector )
{

  if( !this.SelectorIs( selector ) )
  return false;

  let splits = _.strSplitFast
  ({
    src : selector,
    delimeter : [ '{', '}' ],
  });

  if( splits.length < 5 )
  return false;

  splits = _.strSplitsCoupledGroup({ splits : splits, prefix : '{', postfix : '}' });

  if( !splits.some( ( split ) => _.arrayIs( split ) ) )
  return false;

  return true;
}

//

function resolveContextPrepare( o )
{
  let module = this;
  let will = module.will;
  let hardDrive = will.fileProvider.providersWithProtocolMap.file;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.routineOptions( resolveContextPrepare, arguments );

  if( !o.currentContext )
  return o.currentContext;

  if( _.mapIs( o.currentContext ) )
  {
  }
  else if( o.currentContext instanceof will.Reflector )
  {
    let currentContext = Object.create( null );
    currentContext.src = [];
    currentContext.dst = [];
    let o2 = o.currentContext.optionsForFindGroupExport();
    o2.outputFormat = 'absolute';
    let found = fileProvider.filesFindGroups( o2 );
    currentContext.filesGrouped = found.filesGrouped;
    for( let dst in found.filesGrouped )
    {
      currentContext.dst.push( hardDrive.path.nativize( dst ) );
      currentContext.src.push( hardDrive.path.s.nativize( found.filesGrouped[ dst ] ).join( ' ' ) );
    }
    o.currentContext = currentContext; // xxx
  }
  else _.assert( 0 );

  return o.currentContext;
}

resolveContextPrepare.defaults =
{
  currentContext : null,
}

//

function resolve_pre( routine, args )
{
  let o = args[ 0 ];
  if( _.strIs( o ) )
  o = { selector : o }

  _.routineOptions( routine, o );

  if( o.visited === null )
  o.visited = [];

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.assert( _.arrayHas( [ null, 0, false, 'in', 'out' ], o.pathResolving ), 'Unknown value of option path resolving', o.pathResolving );
  _.assert( _.arrayHas( [ 'undefine', 'throw', 'error' ], o.missingAction ), 'Unknown value of option missing action', o.missingAction );
  _.assert( _.arrayHas( [ 'default', 'resolved', 'throw', 'error' ], o.prefixlessAction ), 'Unknown value of option prefixless action', o.prefixlessAction );
  // _.assert( o.prefixlessAction === 'default' || o.defaultResourceName === null, 'prefixlessAction should be "default" if defaultResourceName is provided' );
  _.assert( _.arrayIs( o.visited ) );

  return o;
}

//

function resolve_body( o )
{
  let module = this;
  let will = module.will;
  let current = o.current;
  let hardDrive = will.fileProvider.providersWithProtocolMap.file;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( o.prefixlessAction === 'default' || o.defaultResourceName === null, 'Prefixless action should be "default" if default resource is provided' );

  if( o.currentContext )
  {
    o.currentContext = module.resolveContextPrepare({ currentContext : o.currentContext });
  }

  let result = module._resolveAct( o );

  if( result === undefined )
  {
    debugger;
    result = module.errResolving
    ({
      selector : o.selector,
      current : o.current,
      err : _.ErrorLooking( o.selector, 'was not found' ),
    })
  }

  if( _.errIs( result ) )
  {
    if( o.missingAction === 'undefine' )
    return;
    debugger;
    let err = module.errResolving
    ({
      selector : o.selector,
      current : o.current,
      err : result,
    });
    if( o.missingAction === 'throw' )
    throw err;
    else
    return err;
  }

  result = mapsFlatten( result );
  result = mapValsUnwrap( result );
  result = singleUnwrap( result );
  result = arrayWrap( result );

  return result;

  /* */

  function singleUnwrap( result )
  {

    if( !o.singleUnwrapping )
    return result;

    if( _.any( result, ( e ) => _.mapIs( e ) || _.arrayIs( e ) ) )
    return result;

    if( _.mapIs( result ) )
    {
      if( _.mapKeys( result ).length === 1 )
      result = _.mapVals( result )[ 0 ];
    }
    else if( _.arrayIs( result ) )
    {
      if( result.length === 1 )
      result = result[ 0 ];
    }

    return result;
  }

  //

  function mapsFlatten( result )
  {
    if( o.flattening && _.mapIs( result ) )
    result = _.mapsFlatten([ result ]);
    return result;
  }

  //

  function mapValsUnwrap( result )
  {
    if( !o.mapValsUnwrapping )
    return result
    if( !_.mapIs( result ) )
    return result;
    if( !_.all( result, ( e ) => _.instanceIs( e ) || _.primitiveIs( e ) ) )
    return result;
    return _.mapVals( result );
  }

  //

  function arrayWrap( result )
  {
    if( !o.arrayWrapping )
    return result;
    if( !_.mapIs( result ) )
    return _.arrayAs( result );
    return result;
  }

}

resolve_body.defaults =
{
  selector : null,
  defaultResourceName : null,
  prefixlessAction : 'resolved',
  missingAction : 'throw',
  visited : null,
  currentContext : null,
  current : null,
  criterion : null,
  module : null,
  pathResolving : 'in',
  pathNativizing : 0,
  pathUnwrapping : 1,
  singleUnwrapping : 1,
  mapValsUnwrapping : 1,
  arrayWrapping : 0,
  flattening : 1,
  hasPath : null,
}

let resolve = _.routineFromPreAndBody( resolve_pre, resolve_body );
let resolveMaybe = _.routineFromPreAndBody( resolve_pre, resolve_body );

var defaults = resolveMaybe.defaults;
defaults.missingAction = 'undefine';

//

let onSelectorComposite = _.select.functor.onSelectorComposite({ isStrippedSelector : 1 });
let onSelectorDown = _.select.functor.onSelectorDownComposite({});
function _resolveAct( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result;
  let current = o.current;

  if( o.module === null )
  o.module = module;
  if( o.criterion === null && o.current && o.current.criterion )
  o.criterion = o.current.criterion;

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _resolveAct, arguments );
  _.assert( o.module instanceof will.Module );
  _.assert( o.criterion === null || _.mapIs( o.criterion ) );
  _.assert( _.arrayIs( o.visited ) );

  /* */

  try
  {

    // if( o.selector === 'submodule::*/path::proto*=1' )
    // debugger;

    result = _.select
    ({
      src : module,
      selector : o.selector,
      onSelector : onSelector,
      onSelectorDown : onSelectorDown,
      onUpBegin : onUpBegin,
      onUpEnd : onUpEnd,
      onDownEnd : onDownEnd,
      onQuantitativeFail : onQuantitativeFail,
      missingAction : 'error',
      iteratorExtension :
      {
        resolveOptions : o,
      },
      iterationExtension :
      {
        // compositeRoot : 0,
      },
      iterationPreserve :
      {
        module : o.module,
        exported : null,
        // composite : 0,
      },
    });

    // if( o.selector === 'submodule::*/path::proto*=1' )
    // debugger;

  }
  catch( err )
  {
    debugger;
    throw module.errResolving
    ({
      selector : o.selector,
      current : current,
      err : err,
    });
  }

  return result;

  /* */

  function onSelector( selector )
  {
    let op = this;

    if( !_.strIs( selector ) )
    return;

    if( module.SelectorIs( selector ) )
    {
      return onSelectorComposite.call( op, selector );
    }

    if( o.prefixlessAction === 'default' )
    {
      return selector;
    }
    else if( o.prefixlessAction === 'throw' || o.prefixlessAction === 'error' )
    {
      op.iterator.continue = false;
      let err = module.errResolving
      ({
        selector : selector,
        current : current,
        err : _.ErrorLooking( 'Resource selector should have prefix' ),
      });
      debugger;
      if( op.prefixlessAction === 'throw' )
      throw err;
      debugger;
      op.dst = err;
      return;
    }
    else if( o.prefixlessAction === 'resolved' )
    {
      return;
    }
    else _.assert( 0 );

  }

  /* */

  function onUpBegin()
  {
    let it = this;

    statusUpdate.call( it );
    globCriterionFilter.call( it );

    if( !it.dstWritingDown )
    return;

    /*
    resourceMapSelect, stateUpdate should go after queryParse
    */

    queryParse.call( it );
    resourceMapSelect.call( it );
    stateUpdate.call( it );

  }

  /* */

  function onUpEnd()
  {
    let it = this;

    // if( it.path === "/reflect.submodules.variant2" )
    // debugger;

    exportedWriteThrough.call( it );
    currentExclude.call( it );
    compositePathsSelect.call( it );
    pathsResolve.call( it );
    pathsNativize.call( it );
    pathsUnwrap.call( it );

  }

  //

  function onDownEnd()
  {
    let it = this;

    mapsFlatten.call( it );
    mapValsUnwrap.call( it );
    singleUnwrap.call( it );

  }

  /* */

  function onQuantitativeFail( err )
  {
    let it = this;

    debugger;

    let result = it.dst;
    if( _.mapIs( result ) )
    result = _.mapVals( result );
    if( _.arrayIs( result ) )
    {
      let isString = 1;
      if( result.every( ( e ) => _.strIs( e ) ) )
      isString = 1;
      else
      result = result.map( ( e ) =>
      {
        if( _.strIs( e ) )
        return e;
        if( _.strIs( e.nickName ) )
        return e.nickName;
        isString = 0
      });

      if( isString )
      if( result.length )
      err = _.err( 'Found : ' + result.join( ', ' ), '\n', err );
      else
      err = _.err( 'Found nothing', '\n', err );
    }

    throw err;
  }

  /* */

  function statusUpdate()
  {
    let it = this;

    if( !it.src )
    return;

    _.assert( !it.src.rejoin );

    if( it.src instanceof will.Submodule )
    {
      _.assert( !!it.src.loadedModule, 'not tested' );
      if( it.src.loadedModule )
      it.module = it.src.loadedModule;
    }
    else if( it.src instanceof will.Exported )
    {
      it.exported = it.src;
    }

  }

  /* */

  function globCriterionFilter()
  {
    let it = this;

    if( it.down && it.down.isGlob )
    if(  o.criterion && it.src && it.src.criterionSattisfy )
    {

      if( !it.src.criterionSattisfy( o.criterion ) )
      {
        it.continue = false;
        it.dstWritingDown = false;
      }

    }

  }

  /* */

  function queryParse()
  {
    let it = this;

    if( !it.selector )
    return;

    _.assert( !!it.module );
    let splits = it.module._selectorShortSplit
    ({
      selector : it.selector,
      defaultResourceName : o.defaultResourceName,
    });

    it.parsedSelector = Object.create( null );
    it.parsedSelector.full = splits.join( '' );
    it.parsedSelector.kind = splits[ 0 ];
    it.selector = it.parsedSelector.name = splits[ 2 ];

  }

  /* */

  function resourceMapSelect()
  {
    let it = this;
    let resourceMap;

    if( !it.selector )
    return;

    let kind = it.parsedSelector.kind;

    if( kind === 'this' )
    {
      // debugger; // xxx
      _.assert( _.mapIs( o.currentContext ) );
      resourceMap = o.currentContext;
    }
    else
    {
      resourceMap = it.module.resourceMapForKind( kind );
    }

    if( !resourceMap )
    {
      debugger;
      throw _.ErrorLooking( 'No resource map', _.strQuote( it.parsedSelector.full ) );
    }

    it.src = resourceMap;
    it.iterable = it.onIterable( it.src );

  }

  /* */

  function stateUpdate()
  {
    let it = this;

    if( it.parsedSelector )
    {
      let kind = it.parsedSelector.kind;
      if( kind === 'path' && o.hasPath === null )
      o.hasPath = true;
    }

  }

  /* */

  function exportedWriteThrough()
  {
    let it = this;

    if( it.down && it.parsedSelector && it.parsedSelector.kind === 'exported' )
    {
      let dstWriteDownOriginal = it.dstWriteDown;
      it.dstWriteDown = function writeThrough( eit )
      {
        let r = dstWriteDownOriginal.apply( this, arguments );
        return r;
      }
    }

  }

  /* */

  function currentExclude()
  {
    let it = this;
    if( it.src === o.current && it.down )
    it.dstWritingDown = false;
  }

  /* */

  function compositePathSelect( currentModule, currentResource, filePath, resolving )
  {
    let result = filePath;

    _.assert( _.strIs( result ) || _.strsAreAll( result ) );
    _.assert( arguments.length === 4 );

    if( currentModule.SelectorIsComposite( result ) )
    {

      result = currentModule.pathResolve
      ({
        selector : result,
        visited : _.arrayFlatten( null, [ o.visited, result ] ),
        pathResolving : resolving,
        current : currentResource,
        pathNativizing : o.pathNativizing,
      });

    }

    return result;
  }

  /* */

  function compositePathsSelect()
  {
    let it = this;
    let currentModule = it.module;
    let resource = it.dst;

    if( !it.dstWritingDown ) // xxx
    return;

    if( resource instanceof will.Reflector )
    {
      if( currentModule.SelectorIsComposite( resource.src.prefixPath ) || currentModule.SelectorIsComposite( resource.dst.prefixPath ) )
      {
        resource = it.dst = resource.cloneDerivative(); debugger;
        if( resource.src.prefixPath )
        resource.src.prefixPath = compositePathSelect( currentModule, resource, resource.src.prefixPath, 'in' );
        if( resource.dst.prefixPath )
        resource.dst.prefixPath = compositePathSelect( currentModule, resource, resource.dst.prefixPath, 'in' );
      }
    }

    if( resource instanceof will.PathResource )
    {
      if( currentModule.SelectorIsComposite( resource.path ) )
      {
        resource = it.dst = resource.cloneDerivative();
        resource.path = compositePathSelect( currentModule, resource, resource.path, 0 )
      }
    }

  }

  /* */

  function pathResolve( currentModule, filePath, pathName )
  {
    let it = this;
    let result = filePath;

    _.assert( _.strIs( filePath ) || _.strsAreAll( filePath ) );

    if( it.replicateIteration.composite && it.replicateIteration.compositeRoot !== it.replicateIteration )
    {
      if( it.replicateIteration.key !== 0 )
      return result;
    }

    let prefixPath = '.';
    if( o.pathResolving === 'in' && pathName !== 'in' )
    prefixPath = currentModule.pathMap.in || '.';
    else if( o.pathResolving === 'out' && pathName !== 'out' )
    prefixPath = currentModule.pathMap.out || '.';

    if( currentModule.SelectorIs( prefixPath ) )
    prefixPath = currentModule.pathResolve( prefixPath );
    if( currentModule.SelectorIs( result ) )
    result = currentModule.pathResolve( result );

    // if( currentModule.SelectorIs( result ) && !currentModule.SelectorIsComposite( result ) )
    // result = '{' + result + '}'

    result = path.s.join( currentModule.dirPath, prefixPath, result );

    return result;
  }

  /* */

  function pathsResolve()
  {
    let it = this;
    let currentModule = it.module;
    let resource = it.dst;

    if( !o.pathResolving )
    return;
    if( !it.dstWritingDown )
    return;

    if( it.dst instanceof will.Reflector )
    {

      // if( resource.nickName === "reflector::reflect.submodules.variant2" )
      // debugger;

      resource = it.dst = it.dst.cloneDerivative();

      _.assert( resource.formed >= 1 );

      // if( resource.formed === 0 )
      // resource.form1();
      // if( resource.formed === 1 )
      // resource.form2();
      // _.assert( resource.formed >= 2 );

      // yyy

      let srcHasAnyPath = resource.src.hasAnyPath();
      let dstHasAnyPath = resource.dst.hasAnyPath();

      if( srcHasAnyPath || dstHasAnyPath )
      {
        if( srcHasAnyPath )
        resource.src.prefixPath = pathResolve.call( it, currentModule, resource.src.prefixPath || '.' );
        if( dstHasAnyPath )
        resource.dst.prefixPath = pathResolve.call( it, currentModule, resource.dst.prefixPath || '.' );
      }

    }

    if( it.dst instanceof will.PathResource )
    {
      resource = it.dst = resource.cloneDerivative();
      _.assert( resource.path === null || _.arrayIs( resource.path ) || _.strIs( resource.path ) );
      if( resource.path )
      resource.path = pathResolve.call( it, currentModule, resource.path, resource.name )
    }

  }

  /* */

  function pathNativize( currentModule, filePath, pathName )
  {
    let it = this;
    let result = filePath;

    _.assert( _.strIs( filePath ) || _.strsAreAll( filePath ) );

    result = will.fileProvider.providersWithProtocolMap.file.path.s.nativize( result );

    return result;
  }

  /* */

  function pathsNativize()
  {
    let it = this;
    let currentModule = it.module;
    let resource = it.dst;

    if( !o.pathNativizing )
    return;
    if( !it.dstWritingDown )
    return;

    if( it.dst instanceof will.PathResource )
    {
      resource = it.dst = resource.cloneDerivative(); // xxx : don't do second clone
      _.assert( resource.path === null || _.arrayIs( resource.path ) || _.strIs( resource.path ) );
      if( resource.path )
      resource.path = pathNativize.call( it, currentModule, resource.path, resource.name )
    }

  }

  /* */

  function pathsUnwrap()
  {
    let it = this;
    let currentModule = it.module;

    if( !o.pathUnwrapping )
    return;

    if( it.dst instanceof will.PathResource )
    it.dst = it.dst.path;

    return result;
  }

  /* */

  function singleUnwrap()
  {
    let it = this;
    let currentModule = it.module;

    if( !o.singleUnwrapping )
    return;

    if( _.any( it.dst, ( e ) => _.mapIs( e ) || _.arrayIs( e ) ) )
    return;

    if( _.mapIs( it.dst ) )
    {
      if( _.mapKeys( it.dst ).length === 1 )
      it.dst = _.mapVals( it.dst )[ 0 ];
    }
    else if( _.arrayIs( it.dst ) )
    {
      if( it.dst.length === 1 )
      it.dst = it.dst[ 0 ];
    }

  }

  //

  function mapsFlatten()
  {
    let it = this;
    let currentModule = it.module;
    if( !o.flattening || !_.mapIs( it.dst ) )
    return;

    it.dst = _.mapsFlatten([ it.dst ]);
  }

  //

  function mapValsUnwrap()
  {
    let it = this;
    let currentModule = it.module;

    if( !o.mapValsUnwrapping )
    return;
    if( !_.mapIs( it.dst ) )
    return;
    if( !_.all( it.dst, ( e ) => _.instanceIs( e ) || _.primitiveIs( e ) ) )
    return;

    it.dst = _.mapVals( it.dst );
  }

}

var defaults = _resolveAct.defaults = Object.create( resolve.defaults )

defaults.visited = null;

//

function pathResolve_body( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( _.strIs( o.selector ) || _.arrayIs( o.selector ) );

  let o2 = _.mapExtend( null, o );
  let result = module.resolve( o2 );
  return result;
}

_.routineExtend( pathResolve_body, resolve );

var defaults = pathResolve_body.defaults;
defaults.pathResolving = 'in';
defaults.prefixlessAction = 'resolved';

let pathResolve = _.routineFromPreAndBody( resolve_pre, pathResolve_body );

//

function reflectorResolve_pre( routine, args )
{
  let o = args[ 0 ];
  if( _.strIs( o ) )
  o = { selector : o }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  return o;
}

//

function reflectorResolve_body( o )
{
  let module = this;
  let will = module.will;

  let reflector = module.resolve( o );

  if( o.missingAction === 'undefine' && reflector === undefined )
  return reflector;
  else if( o.missingAction === 'error' && _.errIs( reflector ) )
  return reflector;

  _.sure( reflector instanceof will.Reflector, () => 'Reflector ' + o.selector + ' was not found' + _.strType( reflector ) );

  reflector.form();

  _.assert( reflector.formed === 3, () => reflector.nickName + ' is not formed' );

  return reflector;
}

var defaults = reflectorResolve_body.defaults = Object.create( resolve.defaults );
defaults.selector = null;
defaults.defaultResourceName = 'reflector';
defaults.prefixlessAction = 'default';
defaults.current = null;
defaults.pathResolving = 'in';

let reflectorResolve = _.routineFromPreAndBody( reflectorResolve_pre, reflectorResolve_body );

//

function submodulesResolve_body( o )
{
  let module = this;
  let will = module.will;

  if( _.strIs( o ) )
  o = { selector : o }
  o = _.routineOptions( submodulesResolve_body, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  // o.prefixlessAction = 'default';
  // o.defaultResourceName = 'submodule';

  let result = module.resolve( o );

  return result;
}

var defaults = submodulesResolve_body.defaults = Object.create( resolve.defaults );
defaults.selector = null;
// defaults.singleUnwrapping = 0;
defaults.prefixlessAction = 'default';
defaults.defaultResourceName = 'submodule';

let submodulesResolve = _.routineFromPreAndBody( resolve.pre, submodulesResolve_body );

// --
// exporter
// --

function infoExport()
{
  let module = this;
  let will = module.will;
  let result = '';

  result += module.about.infoExport();
  result += module.execution.infoExport();

  result += module.infoExportPaths( module.pathMap );
  result += module.infoExportResource( module.submoduleMap );
  result += module.infoExportResource( module.reflectorMap );
  result += module.infoExportResource( module.stepMap );
  result += module.infoExportResource( module.buildsSelect({ preffering : 'more' }) );
  result += module.infoExportResource( module.exportsSelect({ preffering : 'more' }) );
  result += module.infoExportResource( module.exportedMap );

  return result;
}

//

function infoExportPaths( paths )
{
  let module = this;
  paths = paths || module.pathMap;
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !Object.keys( paths ).length )
  return '';

  let result = _.color.strFormat( 'Paths', 'highlighted' );

  result += '\n' + _.toStr( paths, { wrap : 0, multiline : 1, levels : 2 } ) + '';

  result += '\n\n';

  return result;
}

//

function infoExportResource( collection )
{
  let module = this;
  let will = module.will;
  let result = '';

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( collection ) || _.arrayIs( collection ) );

  _.each( collection, ( resource, r ) =>
  {
    if( resource.criterion && resource.criterion.predefined )
    return;
    result += resource.infoExport();
    result += '\n\n';
  });

  return result;
}

//

function dataExport( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  o = _.routineOptions( dataExport, arguments );

  result.format = will.WillFile.FormatVersion;
  result.about = module.about.dataExport();
  result.execution = module.execution.dataExport();

  result.path = module.dataExportResources( module.pathResourceMap, o );
  result.submodule = module.dataExportResources( module.submoduleMap, o );
  result.reflector = module.dataExportResources( module.reflectorMap, o );
  result.step = module.dataExportResources( module.stepMap, o );
  result.build = module.dataExportResources( module.buildMap, o );
  result.exported = module.dataExportResources( module.exportedMap, o );

  return result;
}

dataExport.defaults =
{
  compact : 1,
  copyingAggregates : 0,
  copyingNonWritable : 1,
  copyingPredefined : 1,
}

//

function dataExportResources( resources, options )
{
  let module = this;
  let will = module.will;
  let result = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( _.mapIs( resources ) || _.arrayIs( resources ) );

  _.each( resources, ( resource, r ) =>
  {
    // if( resource.criterion && resource.criterion.predefined )
    // return;
    result[ r ] = resource.dataExport( options );
    if( result[ r ] === undefined )
    delete result[ r ];
  });

  return result;
}

//

function resourceImport( resource2 )
{
  let module = this;
  let will = module.will;
  let module2 = resource2.module;

  _.assert( module instanceof will.Module );
  _.assert( module2 === null || module2 instanceof will.Module );
  _.assert( resource2 instanceof will.Resource );

  let resourceData = resource2.dataExport();

  // debugger;

  for( let k in resourceData )
  {
    let value = resourceData[ k ];

    if( _.strIs( value ) && module2 )
    value = module2.resolveMaybe
    ({
      selector : value,
      prefixlessAction : 'resolved',
      pathUnwrapping : 0,
      pathResolving : 0,
    });

    if( _.instanceIsStandard( value ) )
    {
      let subresource = module.resourceImport( value );
      value = subresource.nickName;
    }

    resourceData[ k ] = value;
  }

  resourceData.module = module;
  resourceData.name = module.resourceNameAllocate( resource2.KindName, resource2.name )

  let resource = new resource2.Self( resourceData );
  resource.form1();
  _.assert( module.resolve({ selector : resource.nickName, pathUnwrapping : 0, pathResolving : 0 }).absoluteName === resource.absoluteName );

  return resource;
}

//

function ResourceSetter_functor( op )
{
  _.routineOptions( ResourceSetter_functor, arguments );

  let resourceName = op.resourceName;
  let mapName = op.mapName;
  let mapSymbol = Symbol.for( mapName );

  return function resourceSet( resourceMap2 )
  {
    let module = this;
    let resourceMap = module[ mapSymbol ] = module[ mapSymbol ] || Object.create( null );

    _.assert( arguments.length === 1 );
    _.assert( _.mapIs( resourceMap ) );
    _.assert( _.mapIs( resourceMap2 ) );

    for( let m in resourceMap )
    {
      // debugger;
      let resource = resourceMap[ m ];
      _.assert( _.instanceIs( resource ) );
      _.assert( resource.module === module );
      resource.finit();
    }

    _.assert( _.mapKeys( resourceMap ).length === 0 );

    if( resourceMap2 === null )
    return resourceMap;

    for( let m in resourceMap2 )
    {
      let resource = resourceMap2[ m ];

      // if( !module.preformed )
      // module.preform();

      _.assert( module.preformed === 0 );
      _.assert( _.instanceIs( resource ) );
      _.assert( resource.module !== module );

      if( resource.module !== null )
      resource = resource.clone();
      _.assert( resource.module === null );
      resource.module = module;
      resource.form1();
      _.assert( !_.instanceIsFinited( resource ) );
    }

    return resourceMap;
  }

}

ResourceSetter_functor.defaults =
{
  resourceName : null,
  mapName : null,
}

// --
// relations
// --

let filePathSymbol = Symbol.for( 'filePath' );
let dirPathSymbol = Symbol.for( 'dirPath' );
let clonePathSymbol = Symbol.for( 'clonePath' );
let remotePathSymbol = Symbol.for( 'remotePath' );

let Composes =
{

  filePath : null,
  dirPath : null,
  clonePath : null,
  remotePath : null,
  // willPath : null,

  configName : null,

  isRemote : null,
  isDownloaded : null,
  isUpToDate : null,

  verbosity : 0,
  alias : null,

}

let Aggregates =
{

  about : _.define.instanceOf( _.Will.ParagraphAbout ),
  execution : _.define.instanceOf( _.Will.ParagraphExecution ),

  submoduleMap : _.define.own({}),
  pathResourceMap : _.define.own({}),
  reflectorMap : _.define.own({}),
  stepMap : _.define.own({}),
  buildMap : _.define.own({}),
  exportedMap : _.define.own({}),

}

let Associates =
{
  will : null,
  supermodule : null,
  associatedSubmodule : null,
}

let Restricts =
{

  id : null,
  // errors : _.define.own([]),
  stager : null,
  willFilesReadBeginTime : null,

  willFileArray : _.define.own([]),
  willFileWithRoleMap : _.define.own({}),
  pathMap : _.define.own({}),

  preformed : 0,
  willFilesFound : 0,
  willFilesOpened : 0,
  submodulesFormed : 0,
  resourcesFormed : 0,
  totallyFormed : 0,

  preformRady : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'preformRady' }) ),
  willFilesFindReady : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'willFilesFindReady' }) ),
  willFilesOpenReady : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'willFilesOpenReady' }) ),
  submodulesFormReady : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'submodulesFormReady' }) ),
  resourcesFormReady : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'resourcesFormReady' }) ),
  ready : _.define.own( _.Consequence({ resourceLimit : 1, tag : 'ready' }) ),

}

let Statics =
{

  SelectorIs,
  SelectorIsComposite,

  ResourceSetter_functor,
  DirPathFromFilePaths,
  Counter : 0,

}

let Forbids =
{
  name : 'name',
  exportMap : 'exportMap',
  exported : 'exported',
  export : 'export',
  downloaded : 'downloaded',
  formed : 'formed',
  formReady : 'formReady',
}

let Accessors =
{

  about : { setter : _.accessor.setter.friend({ name : 'about', friendName : 'module', maker : _.Will.ParagraphAbout }) },
  execution : { setter : _.accessor.setter.friend({ name : 'execution', friendName : 'module', maker : _.Will.ParagraphExecution }) },

  submoduleMap : { setter : ResourceSetter_functor({ resourceName : 'Submodule', mapName : 'submoduleMap' }) },
  pathResourceMap : { setter : ResourceSetter_functor({ resourceName : 'PathResource', mapName : 'pathResourceMap' }) },
  reflectorMap : { setter : ResourceSetter_functor({ resourceName : 'Reflector', mapName : 'reflectorMap' }) },
  stepMap : { setter : ResourceSetter_functor({ resourceName : 'Step', mapName : 'stepMap' }) },
  buildMap : { setter : ResourceSetter_functor({ resourceName : 'Build', mapName : 'buildMap' }) },
  exportedMap : { setter : ResourceSetter_functor({ resourceName : 'Exported', mapName : 'exportedMap' }) },

  nickName : { getter : _nickNameGet, combining : 'rewrite', readOnly : 1 },
  absoluteName : { getter : _absoluteNameGet, readOnly : 1 },
  inPath : { getter : inPathGet, readOnly : 1 },
  outPath : { getter : outPathGet, readOnly : 1 },

  filePath : { getter : filePathGet, setter : filePathSet },
  dirPath : { getter : dirPathGet, setter : dirPathSet },
  clonePath : { getter : clonePathGet, setter : clonePathSet },
  remotePath : { getter : remotePathGet, setter : remotePathSet },
  willPath : { getter : willPathGet, readOnly : 1 },

}

// --
// declare
// --

let Proto =
{

  // inter

  finit,
  init,
  copy,
  unform,
  preform,
  preform1,
  preform2,
  predefinedForm,

  // etc

  shell,
  hasAnyError,
  cleanWhat,
  clean,

  // opener

  DirPathFromFilePaths,
  prefixPathForRole,
  prefixPathForRoleMaybe,
  isOpened,

  stateResetError,

  willFilesPick,
  _willFileFindMaybe,
  _willFilesFindMaybe,
  willFilesFind,

  willFilesOpen,
  _willFilesOpen,
  _willFilesCacheOpen,
  _willFilesCacheSave,

  willFilesReadBegin,
  willFilesReadEnd,

  _willFilesExport,
  willFileEach,

  // submodule

  submodulesCloneDirGet,

  submodulesAllAreDownloaded,
  submodulesHaveAnyError,

  _submodulesDownload,
  submodulesDownload,
  submodulesUpgrade,
  submodulesClean,

  submodulesFormSkip,
  submodulesForm,
  _submodulesForm,

  submodulesReload,

  // remote

  remoteIsRemote,
  remoteIsDownloaded,
  remoteIsUpToDate,

  remoteForm,
  remoteFormAct,
  _remoteDownload,
  remoteDownload,
  remoteUpgrade,

  // resource

  resourcesFormSkip,
  resourcesForm,
  _resourcesForm,
  _resourcesFormAct,

  resourceClassForKind,
  resourceMapForKind,
  resourceObtain,
  resourceAllocate,
  resourceNameAllocate,

  // path

  filePathChange,
  _filePathChange,
  inPathGet,
  outPathGet,

  filePathSet,
  dirPathSet,
  clonePathSet,
  remotePathSet,

  // accessor

  _nickNameGet,

  // selector

  _buildsSelect,
  buildsSelect,
  exportsSelect,
  willFilesSelect,

  // resolver

  errResolving,
  resolveContextPrepare,

  _selectorShortSplitAct,
  _selectorShortSplit,
  selectorLongSplit,
  selectorParse,
  SelectorIs,
  SelectorIsComposite,

  resolve,
  resolveMaybe,
  _resolveAct,

  pathResolve,
  reflectorResolve,
  submodulesResolve,

  // exporter

  infoExport,
  infoExportPaths,
  infoExportResource,

  dataExport,
  dataExportResources,

  resourceImport,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

_.staticDecalre
({
  prototype : _.Will.prototype,
  name : Self.shortName,
  value : Self,
});

})();
