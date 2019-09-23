( function _MainBase_s_( ) {

'use strict';

/**
 * Utility to manage modules of complex modular systems.
  @module Tools/Willbe
*/

/**
 * @file Main.bse.s
 */

/*

= Principles

- Willbe prepends all relative paths by path::in. path::out and path::temp are prepended by path::in as well.
- Willbe prepends path::in by module.dirPath, a directory which has the willfile.
- Major difference between generated out-willfiles and manually written willfile is section exported. out-willfiles has such section, manually written willfile does not.
- Output files are generated and input files are for manual editing, but the utility can help with it.

*/

/*

= Requested features

- Command .submodules.update should change back manually updated fixated submodules.
- Faster loading, perhaps without submodules
- Timelapse for transpilation
- Reflect submodules into dir with the same name as submodule

*/

//

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

}

//

let _ = wTools;
let Parent = null;
let Self = function wWill( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Will';

// --
// inter
// --

function finit()
{
  if( this.formed )
  this.unform();
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let will = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let logger = will.logger = new _.Logger({ output : _global_.logger, name : 'will' });

  _.workpiece.initFields( will );
  Object.preventExtensions( will );

  _.assert( logger === will.logger );

  if( o )
  will.copy( o );

}

//

function unform()
{
  let will = this;

  _.assert( arguments.length === 0 );
  _.assert( !!will.formed );

  /* begin */

  /* end */

  will.formed = 0;
  return will;
}

//

function form()
{
  let will = this;

  if( will.formed >= 1 )
  return will;

  will.formAssociates();

  _.assert( arguments.length === 0 );
  _.assert( !will.formed );

  /* begin */

  /* end */

  will.formed = 1;
  return will;
}

//

function formAssociates()
{
  let will = this;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !will.formed );
  _.assert( !!logger );
  _.assert( logger.verbosity === will.verbosity );

  if( !will.fileProvider )
  {

    let hub = _.FileProvider.System({ providers : [] });

    _.FileProvider.Git().providerRegisterTo( hub );
    _.FileProvider.Npm().providerRegisterTo( hub );
    _.FileProvider.Http().providerRegisterTo( hub );

    let defaultProvider = _.FileProvider.Default();
    let image = _.FileFilter.Image({ originalFileProvider : defaultProvider });
    let archive = new _.FilesGraphArchive({ imageFileProvider : image });
    image.providerRegisterTo( hub );
    hub.defaultProvider = image;

    will.fileProvider = hub;

  }

  if( !will.filesGraph )
  will.filesGraph = _.FilesGraphOld({ fileProvider : will.fileProvider });

  let logger2 = new _.Logger({ output : logger, name : 'will.providers' });

  will.fileProvider.logger = logger2;
  for( var f in will.fileProvider.providersWithProtocolMap )
  {
    let fileProvider = will.fileProvider.providersWithProtocolMap[ f ];
    fileProvider.logger = logger2;
  }

  _.assert( will.fileProvider.logger === logger2 );
  _.assert( logger.verbosity === will.verbosity );
  _.assert( will.fileProvider.logger !== will.logger );

  will._verbosityChange();

  _.assert( logger2.verbosity <= logger.verbosity );
}

// --
// etc
// --

function _verbosityChange()
{
  let will = this;

  _.assert( arguments.length === 0 );
  _.assert( !will.fileProvider || will.fileProvider.logger !== will.logger );

  if( will.fileProvider )
  will.fileProvider.verbosity = will.verbosity-2;

}

//

function vcsFor( o )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  if( !_.mapIs( o ) )
  o = { filePath : o }

  _.assert( arguments.length === 1 );
  _.routineOptions( vcsFor, o );
  _.assert( !!will.formed );

  if( _.arrayIs( o.filePath ) && o.filePath.length === 0 )
  return null;

  if( !o.filePath )
  return null;

  let result = fileProvider.providerForPath( o.filePath );

  if( !result )
  return null

  if( !result.isVcs )
  return null

  return result;
}

vcsFor.defaults =
{
  filePath : null,
}

//

function resourcesInfoExport( o )
{
  let will = this;
  let result = Object.create( null );

  o = _.routineOptions( resourcesInfoExport, arguments );

  let names =
  {
    openersArray : 'openers',
    modulesArray : 'modules',
    willfilesArray : 'willfiles',
  }

  for( let n in names )
  {
    if( n === 'willfilesArray' )
    result[ names[ n ] ] = _.filter( will[ n ], ( willf ) => willf.filePath + ' # ' + willf.id );
    else
    result[ names[ n ] ] = _.filter( will[ n ], ( e ) => e.commonPath + ' # ' + e.id );
  }

  result.openersErrors = _.filter( will.openersErrorsArray, ( r ) => r.err.originalMessage || r.err.message );

  if( o.stringing )
  result = _.toStrNice( result );

  return result;
}

resourcesInfoExport.defaults =
{
  stringing : 1,
}

// --
// defaults
// --

function instanceDefaultsApply( o )
{
  let will = this;

  _.assert( arguments.length === 1 );

  for( let d in will.Defaults )
  {
    if( o[ d ] === null )
    o[ d ] = will[ d ];
  }

  return o;
}

//

function instanceDefaultsSupplement( o )
{
  let will = this;

  _.assert( arguments.length === 1 );

  for( let d in will.Defaults )
  {
    if( o[ d ] !== null && o[ d ] !== undefined )
    if( will[ d ] === null )
    will[ d ] = o[ d ];
  }

  return will;
}

//

function instanceDefaultsExtend( o )
{
  let will = this;

  _.assert( arguments.length === 1 );

  for( let d in will.Defaults )
  {
    if( o[ d ] !== null && o[ d ] !== undefined )
    will[ d ] = o[ d ];
  }

  return will;
}

//

function instanceDefaultsReset()
{
  let will = this;
  let FieldsOfTightGroups = will.FieldsOfTightGroups;

  _.assert( arguments.length === 0 );

  for( let d in will.Defaults )
  {
    _.assert( FieldsOfTightGroups[ d ] !== undefined );
    _.assert( _.primitiveIs( FieldsOfTightGroups[ d ] ) );
    will[ d ] = FieldsOfTightGroups[ d ];
  }

  return will;
}

//

function prefer( o )
{
  let will = this;
  let ready = new _.Consequence();

  o = _.routineOptions( prefer, arguments );

  forward();
  will.instanceDefaultsApply( o );
  forward();
  will.instanceDefaultsExtend( o );

  return will;

  function forward()
  {

    if( _.boolLike( o.allOfMain ) )
    {
      o.allOfMain = !!o.allOfMain;
      if( o.attachedWillfilesFormedOfMain === null )
      o.attachedWillfilesFormedOfMain = o.allOfMain;
      if( o.peerModulesFormedOfMain === null )
      o.peerModulesFormedOfMain = o.allOfMain;
      if( o.subModulesFormedOfMain === null )
      o.subModulesFormedOfMain = o.allOfMain;
      if( o.resourcesFormedOfMain === null )
      o.resourcesFormedOfMain = o.allOfMain;
    }

    if( _.boolLike( o.allOfSub ) )
    {
      o.allOfSub = !!o.allOfSub;
      if( o.attachedWillfilesFormedOfSub === null )
      o.attachedWillfilesFormedOfSub = o.allOfSub;
      if( o.peerModulesFormedOfSub === null )
      o.peerModulesFormedOfSub = o.allOfSub;
      if( o.subModulesFormedOfSub === null )
      o.subModulesFormedOfSub = o.allOfSub;
      if( o.resourcesFormedOfSub === null )
      o.resourcesFormedOfSub = o.allOfSub;
    }

  }

}

prefer.defaults =
{

  attachedWillfilesFormedOfMain : null,
  peerModulesFormedOfMain : null,
  subModulesFormedOfMain : null,
  resourcesFormedOfMain : null,
  allOfMain : null,

  attachedWillfilesFormedOfSub : null,
  peerModulesFormedOfSub : null,
  subModulesFormedOfSub : null,
  resourcesFormedOfSub : null,
  allOfSub : null,

  verbosity : null,
  // recursiveExport : null,

}

// --
// module
// --

function moduleEachAt( o )
{
  let will = this.form();
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;
  let con;
  let errs = [];

  _.sure( _.strDefined( o.selector ), 'Expects string' );
  _.assert( arguments.length === 1 );

  if( _.strEnds( o.selector, '::' ) )
  o.selector = o.selector + '*';

  /* */

  if( will.Resolver.selectorIs( o.selector ) )
  {

    let opener = o.currentOpener;

    debugger;
    if( !opener )
    opener = will.openerMake
    ({
      willfilesPath : path.trail( path.current() ),
      searching : 'strict',
    });
    opener.find();

    // if( !o.currentOpener )
    // opener = o.currentOpener = will.ModuleOpener({ will : will, willfilesPath : path.trail( path.current() ) }).preform();
    // opener.find();

    con = opener.openedModule.ready.split();
    con.then( () =>
    {
      let con2 = new _.Consequence();
      let resolved = opener.openedModule.submodulesResolve({ selector : o.selector, preservingIteration : 1 });
      resolved = _.arrayAs( resolved );

      debugger;
      for( let s = 0 ; s < resolved.length ; s++ ) con2.then( ( arg ) => /* !!! replace by concurrent, maybe */
      {
        let it1 = resolved[ s ];
        let opener = it1.currentModule;

        debugger;
        let it2 = Object.create( null );
        it2.currentOpener = opener.openerMake(); // zzz

        if( _.arrayIs( it1.dst ) || _.strIs( it1.dst ) )
        it2.currentPath = it1.dst;
        it2.options = o;

        if( o.onBegin )
        o.onBegin( it2 )
        if( o.onEnd )
        return o.onEnd( it2 );

        return null;
      });
      con2.take( null );
      return con2;
    });

    opener.open();

    // opener.openedModule.stager.stageStateSkipping( 'resourcesFormed', 1 );
    // opener.openedModule.stager.stageStatePausing( 'picked', 0 );
    // opener.openedModule.stager.tick();

  }
  else
  {

    // o.selector = path.resolve( o.selector );
    con = new _.Consequence().take( null );

    if( !path.isGlob( o.selector ) )
    {
      if( _.strEnds( o.selector, '/.' ) )
      o.selector = _.strRemoveEnd( o.selector, '/.' ) + '/*';
      else if( o.selector === '.' )
      o.selector = '*';
      else if( _.strEnds( o.selector, '/' ) )
      o.selector += '*';
      else
      o.selector += '/*';
    }

    let files;
    try
    {
      files = will.willfilesList
      ({
        dirPath : o.selector,
        includingInFiles : 1,
        includingOutFiles : 1,
      });
    }
    catch( err )
    {
      throw _.errBrief( err );
    }

    let filesMap = Object.create( null );
    for( let f = 0 ; f < files.length ; f++ ) con
    .then( ( arg ) => /* !!! replace by concurrent, maybe */
    {
      let file = files[ f ];

      if( filesMap[ file.absolute ] )
      {
        return true;
      }

      debugger;
      opener = will.openerMake
      ({
        willfilesPath : file.absolute,
        searching : 'smart',
      });
      opener.find();

      // let opener = will.openerMake({ willfilesPath : file.absolute });
      // opener.find();
      // let opener = will.ModuleOpener({ will : will, willfilesPath : file.absolute }).preform();
      // opener.find();

      let it = Object.create( null );
      it.currentOpener = opener;
      it.options = o;

      opener.openedModule.stager.stageConsequence( 'preformed' ).then( ( arg ) =>
      {
        debugger;
        if( o.onBegin )
        return o.onBegin( it );
        return arg;
      });

      opener.open();

      // opener.openedModule.stager.stageStateSkipping( 'resourcesFormed', 1 );
      // opener.openedModule.stager.stageStatePausing( 'picked', 0 );
      // opener.openedModule.stager.tick();

      return opener.openedModule.ready.split().then( function( arg )
      {
        debugger;
        _.assert( opener.willfilesArray.length > 0 );
        if( opener.willfilesPath )
        _.mapSet( filesMap, opener.willfilesPath, true );

        let r = null;
        if( o.onEnd )
        r = o.onEnd( it );

        return r;
      })

    })
    .finally( ( err, arg ) =>
    {
      if( err )
      {
        debugger;
        if( o.onError )
        o.onError( err );
        errs.push( _.errBrief( err ) );
        return null;
      }
      return arg;
    });

  }

  /* */

  con.finally( ( err, arg ) =>
  {
    debugger;
    if( errs.length )
    {
      errs.forEach( ( err, index ) => index > 0 ? _.errAttend( err ) : null );
    }
    if( err )
    {
      throw _.err( err );
    }
    if( errs.length )
    {
      throw errs[ 0 ];
    }
    return o;
  });

  /* */

  return con;
}

moduleEachAt.defaults =
{
  currentOpener : null,
  selector : null,
  onBegin : null,
  onEnd : null,
}

//

function moduleWithAt( o )
{
  let will = this.form();
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;
  let con;

  _.sure( _.strDefined( o.selector ), 'Expects string' );
  _.assert( arguments.length === 1 );

  /* */

  will._willfilesReadBegin();
  con = new _.Consequence().take( null );

  let it = Object.create( null );
  it.options = o;
  it.errs = [];
  it.openers = [];

  let files;
  try
  {
    files = will.willfilesList
    ({
      dirPath : o.selector,
      includingInFiles : 1,
      includingOutFiles : 1,
      // prefferedRecursive : 0,
    });
  }
  catch( err )
  {
    throw _.errBrief( err );
  }

  // debugger;
  for( let f = 0 ; f < files.length ; f++ ) con
  .then( ( arg ) => /* !!! replace by concurrent, maybe */
  {
    let opener;
    try
    {
      let file = files[ f ];

      // debugger;
      let opener = will.openerMake
      ({
        willfilesPath : file.absolute,
        searching : 'smart',
      });
      opener.find();
      opener.open();

      // opener = will.ModuleOpener({ will : will, willfilesPath : file.absolute })
      // opener.preform();
      // opener.find();
      //
      // if( !opener.openedModule.stager.stageStatePerformed( 'formed' ) )
      // {
      //   opener.openedModule.stager.stageStateSkipping( 'resourcesFormed', 1 );
      //   opener.openedModule.stager.stageStatePausing( 'picked', 0 );
      //   opener.openedModule.stager.tick();
      // }

      return opener.openedModule.ready.split()
      .then( function( arg )
      {
        _.assert( opener.willfilesArray.length > 0 );
        let l = it.openers.length;
        _.arrayAppendOnce( it.openers, opener, ( e ) => e.openedModule );
        if( l === it.openers.length )
        opener.finit();
        _.assert( !_.arrayHas( it.openers, null ) )
        return arg;
      })
      .catch( function( err )
      {
        debugger;
        err = _.errBrief( err );
        it.errs.push( err );
        opener.finit();
        throw err;
      });
    }
    catch( err )
    {
      debugger;
      err = _.errBrief( err );
      it.errs.push( err );
      if( opener )
      opener.finit();
      throw err;
    }
  })

  /* */

  con.finally( ( err, arg ) =>
  {

    it.sortedModules = will.modulesTopologicalSort( will.modulesArray );

    // will._willfilesReadLog();

    if( err )
    throw err;
    return it;
  });

  /* */

  return con;
}

moduleWithAt.defaults =
{
  selector : null,
}

//

function moduleAt( willfilesPath )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 1 );

  let commonPath = will.AbstractModule.CommonPathFor( willfilesPath );

  return will.moduleWithCommonPathMap[ commonPath ];
}

//

function moduleIdUnregister( openedModule )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );
  _.assert( openedModule instanceof will.OpenedModule );
  _.assert( openedModule.id > 0 );

  _.assert( will.moduleWithIdMap[ openedModule.id ] === openedModule || will.moduleWithIdMap[ openedModule.id ] === undefined );
  delete will.moduleWithIdMap[ openedModule.id ];
  _.assert( _.arrayCountElement( _.mapVals( will.moduleWithIdMap ), openedModule ) === 0 );
  _.arrayRemoveOnceStrictly( will.modulesArray, openedModule );

  will.modulesGraphInvalidate();
}

//

function moduleIdRegister( openedModule )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( openedModule instanceof will.OpenedModule );
  _.assert( arguments.length === 1 );
  _.assert( openedModule.id > 0 );

  _.assert( will.moduleWithIdMap[ openedModule.id ] === openedModule || will.moduleWithIdMap[ openedModule.id ] === undefined );
  will.moduleWithIdMap[ openedModule.id ] = openedModule;
  _.assert( _.arrayCountElement( _.mapVals( will.moduleWithIdMap ), openedModule ) === 1 );
  _.arrayAppendOnceStrictly( will.modulesArray, openedModule );

  will.modulesGraphInvalidate();
}

//

function modulePathUnregister( openedModule )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );
  _.assert( openedModule instanceof will.OpenedModule );
  _.assert( openedModule._registeredPath === null || openedModule._registeredPath === openedModule.commonPath );

  if( !openedModule._registeredPath )
  return;

  if( openedModule.commonPath )
  {
    _.assert( _.strIs( openedModule.commonPath ) );
    _.assert( will.moduleWithCommonPathMap[ openedModule.commonPath ] === openedModule );
    delete will.moduleWithCommonPathMap[ openedModule.commonPath ];
  }

  _.assert( _.arrayCountElement( _.mapVals( will.moduleWithCommonPathMap ), openedModule ) === 0 );

}

//

function modulePathRegister( openedModule )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  openedModule._registeredPath = openedModule.commonPath;

  _.assert( openedModule instanceof will.OpenedModule );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( openedModule.commonPath ) );

  _.assert
  (
    will.moduleWithCommonPathMap[ openedModule.commonPath ] === openedModule || will.moduleWithCommonPathMap[ openedModule.commonPath ] === undefined,
    () => 'Different instance of ' + openedModule.constructor.name + ' is registered at ' + openedModule.commonPath
  );
  will.moduleWithCommonPathMap[ openedModule.commonPath ] = openedModule;
  _.assert( _.arrayCountElement( _.mapVals( will.moduleWithCommonPathMap ), openedModule ) === 1 );

}

//

function modulesGraphInvalidate()
{
  let will = this;

  if( will.graphGroup )
  {
    will.graphGroup.sys.finit();
    will.graphGroup = null;
  }

}

//

function modulesGraphGroupObtain()
{
  let will = this;

  let group = will.graphGroup;
  if( group )
  return group;

  let sys = new _.graph.AbstractGraphSystem();
  group = will.graphGroup = sys.groupMake
  ({
    onNodeNameGet : ( module ) => module.qualifiedName,
    onOutNodesFor : onOutNodesFor,
    onInNodesFor : onInNodesFor,
  });

  group.nodesAdd( will.modulesArray );

  // debugger;
  // logger.log( group.exportInfo() );
  // debugger;

  return group;

  function onOutNodesFor( module )
  {
    let result = module.submoduleMap ? _.mapVals( module.submoduleMap ) : [];
    result = result.map( ( module ) => module.opener );
    result = result.map( ( module ) => module ? module.openedModule : module );
    result = result.filter( ( module ) => !!module );
    result.forEach( ( module ) => _.assert( module instanceof will.OpenedModule, () => 'Not module ' + _.strType( module ) ) );
    return result;
  }

  function onInNodesFor( module )
  {
    if( module.superModules )
    return module.superModules;
    if( module.supermodule )
    return [ module.supermodule ];
    return [];
  }

}

//

function modulesTopologicalSort( modules )
{
  let will = this;

  _.assert( arguments.length === 0 || arguments.length === 1 )

  modules = modules || will.modulesArray;

  let group = will.modulesGraphGroupObtain();
  let sorted = group.topologicalSortCycledSourceBased( modules );

  return sorted;
}

//

function modulesInfoExportAsTree( modules )
{
  let will = this;

  _.assert( arguments.length === 0 || arguments.length === 1 )

  modules = modules || will.modulesArray;

  let group = will.modulesGraphGroupObtain();
  let info = group.nodesExportInfoTree( modules );

  return info;
}

// --
// opener
// --

function openerMake_pre( routine, args )
{
  let module = this;
  let o = args[ 0 ];

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { selector : o }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.assert( !o.isMain || !o.mainOpener || !o.opener || o.mainOpener === o.opener );

  return o;
}

function openerMake_body( o )
{
  let will = this.form();
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;
  let madeOpener = null;

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( openerMake_body, arguments );

  try
  {

    if( o.isMain === null )
    {
      if( will.mainOpener )
      o.isMain = will.mainOpener === o.opener;
      else
      o.isMain = true;
    }

    if( !o.opener )
    o.opener = o.opener || Object.create( null );
    o.opener.will = will;

    if( !o.willfilesPath && !o.opener.willfilesPath )
    o.willfilesPath = o.willfilesPath || fileProvider.path.current();
    if( o.willfilesPath )
    o.opener.willfilesPath = o.willfilesPath;

    if( !( o.opener instanceof will.ModuleOpener ) )
    o.opener = madeOpener = will.ModuleOpener( o.opener );

    _.assert( o.opener instanceof will.ModuleOpener );

    if( o.searching )
    o.opener.searching = o.searching;

    if( !o.opener.will )
    o.opener.will = will;

    if( o.isMain !== null )
    {
      o.opener.isMain = !!o.isMain;
    }

    o.opener.preform()


    return o.opener;
  }
  catch( err )
  {
    debugger;

    // try
    // {
    //   if( madeOpener )
    //   {
    //     o.opener = null;
    //     madeOpener.finit();
    //   }
    // }
    // catch( err )
    // {
    //   throw _.err( `Failed to finit module\n`, err );
    // }

    if( o.throwing )
    throw _.err( err, `\nFailed to make module ${o.willfilesPath}` );

    return null;
  }
}

openerMake_body.defaults =
{

  opener : null,
  throwing : 1,

  willfilesPath : null, // xxx : remove later
  isMain : null, // xxx : remove later
  searching : null, // xxx : remove later

}

let openerMake = _.routineFromPreAndBody( openerMake_pre, openerMake_body );

//

function openersAdoptModule( module )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = 0;
  let commonPath = module.commonPath;

  _.assert( arguments.length === 1 );

  will.openersArray.forEach( ( opener ) =>
  {
    if( opener.commonPath !== commonPath )
    return;
    if( opener.openedModule == module )
    return;

    _.assert( opener.openedModule === null );
    opener.moduleAdopt( module );
    result += 1;

    if( !opener.isDownloaded )
    {
      debugger;
      opener.isDownloaded = true;
    }

  });

  return result;
}

//

function openerUnregister( opener )
{
  let will = this;

  _.assert( will.openerModuleWithIdMap[ opener.id ] === opener );
  delete will.openerModuleWithIdMap[ opener.id ];
  _.assert( _.arrayCountElement( _.mapVals( will.openerModuleWithIdMap ), opener ) === 0 );
  _.arrayRemoveOnceStrictly( will.openersArray, opener );

}

//

function openerRegister( opener )
{
  let will = this;

  _.assert( opener.id > 0 );
  will.openerModuleWithIdMap[ opener.id ] = opener;
  _.arrayAppendOnceStrictly( will.openersArray, opener );
  _.assert( _.arrayCountElement( _.mapVals( will.openerModuleWithIdMap ), opener ) === 1 );

}

//

function openersErrorsRemoveOf( opener )
{
  let will = this;

  _.assert( arguments.length === 1 );
  _.assert( opener instanceof will.ModuleOpener );

  will.openersErrorsArray = will.openersErrorsArray.filter( ( r ) =>
  {
    if( r.opener === opener )
    return false;
  });

  return will;
}

//

function openersErrorsRemoveAll()
{
  let will = this;
  _.assert( arguments.length === 0 );
  will.openersErrorsArray.splice( 0, will.openersErrorsArray.length );
}

// --
// willfile
// --

function readingBegin()
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  will.willfilesReadBeginTime = null;
  will.willfilesReadEndTime = null;

  return will;
}

//

function readingEnd()
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  will._willfilesReadEnd( will.mainOpener ? will.mainOpener.openedModule : null );

  return will;
}

//

function _willfilesReadBegin()
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  // _.assert( will.mainModule === null || will.mainModule instanceof will.OpenedModule );
  _.assert( will.mainOpener === null || will.mainOpener instanceof will.ModuleOpener );

  will.willfilesReadBeginTime = will.willfilesReadBeginTime || _.timeNow();

}

//

function _willfilesReadEnd( module )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );
  _.assert( module instanceof will.OpenedModule );
  _.assert( will.mainOpener === null || will.mainOpener instanceof will.ModuleOpener );

  if( will.willfilesReadEndTime )
  return will;

  if( will.mainOpener && module === will.mainOpener.openedModule && !module.original )
  will._willfilesReadLog();

  return will;
}

//

function _willfilesReadLog()
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !will.willfilesReadEndTime );

  will.willfilesReadEndTime = will.willfilesReadEndTime || _.timeNow();

  if( will.verbosity >= 2 )
  {
    let spent = _.timeSpentFormat( will.willfilesReadEndTime - will.willfilesReadBeginTime );
    logger.log( ' . Read', will.willfilesArray.length, 'willfile(s) in', spent, '\n' );
  }

}

//

function willfilesList( o )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( _.strIs( o ) )
  o = { dirPath : o }

  if( o.dirPath === '.' )
  o.dirPath = './';

  o.dirPath = path.normalize( o.dirPath );
  o.dirPath = _.strRemoveEnd( o.dirPath, '.' );
  o.dirPath = path.resolve( o.dirPath );

  _.routineOptions( willfilesList, o );
  _.assert( arguments.length === 1 );
  _.assert( !!will.formed );
  _.assert( _.boolIs( o.recursive ) );

  let filter =
  {
    filePath : o.dirPath,
    maskTerminal :
    {
      includeAny : /(\.|(\.will(\.[^.]*)?))$/,
      excludeAny :
      [
        /\.DS_Store$/,
        /(^|\/)-/,
      ],
      includeAll : []
    }
  };

  if( !o.includingInFiles )
  filter.maskTerminal.includeAll.push( /\.out(\.|$)/ )
  if( !o.includingOutFiles )
  filter.maskTerminal.excludeAny.push( /\.out(\.|$)/ )

  if( !path.isGlob( o.dirPath ) )
  filter.recursive = o.recursive ? 2 : 1;

  let o2 =
  {
    filter : filter,
    maskPreset : 0,
    mandatory : 0,
    mode : 'distinct',
  }

  filter.filePath = path.mapExtend( filter.filePath );
  filter.filePath = path.filterPairs( filter.filePath, ( it ) =>
  {
    if( !_.strIs( it.dst ) )
    return { [ it.src ] : it.dst };

    let hasExt = /\.will\.[^\.]+$/.test( it.src );
    let hasWill = /\.will\./.test( it.src );
    let hasImEx = /(^|\.|\/)(im|ex)\./.test( it.src );

    let postfix = '';
    if( !hasWill )
    {
      postfix += '?(.im|.ex|)';
      if( o.includingOutFiles && o.includingInFiles )
      {
        postfix += '?(.out)';
      }
      else if( o.includingInFiles )
      {
        postfix += '';
      }
      else if( o.includingOutFiles )
      {
        postfix += '.out';
      }
      postfix += '.will';
    }

    if( !hasExt )
    postfix += '.*';

    it.src += postfix;

    return { [ it.src ] : it.dst };
  });

  let files = fileProvider.filesFind( o2 );

  return files;
}

willfilesList.defaults =
{
  dirPath : null,
  includingInFiles : 1,
  includingOutFiles : 1,
  recursive : false,
}

//

function willfileWithCommon( commonPath )
{
  let will = this;
  commonPath = will.AbstractModule.CommonPathFor( commonPath );
  let result = will.willfileWithCommonPathMap[ commonPath ];
  if( !result || !result.length )
  return null
  return result;
}

//

function _willfileWithFilePath( filePath )
{
  let will = this;
  let result = will.willfileWithFilePathPathMap[ filePath ];
  if( !result )
  return null
  return result;
}

//

let _willfileWithFilePath2 = _.vectorize( _willfileWithFilePath );
function willfileWithFilePath( filePath )
{
  let will = this;
  let result = _willfileWithFilePath2.apply( this, arguments );
  if( _.arrayIs( result ) )
  {
    result = result.filter( ( r ) => r !== null );
    if( !result.length )
    return null;
  }
  return result;
}

//

function willfileFor( o )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let r = Object.create( null );

  _.routineOptions( willfileFor, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o.willf ) );
  _.assert( _.arrayHas( [ false, 0, 'supplement' ], o.combining ) );

  o.willf.will = will;

  let willf = will.willfileWithFilePath( o.willf.filePath );
  if( willf )
  {
    r.willf = willf;
    r.new = false;
    if( o.combining === 'supplement' )
    return r;
    debugger;
    _.assert( !o.willf.data );
    _.assert( !o.willf.structure );
    _.arrayAs( willf ).forEach( ( willf ) =>
    {
      if( !o.combining )
      throw _.err( `Cant redefine willfile ${willf.filePath}, because {- o.combining -} is off` );
      willf.copy( o.willf );
    });
  }
  else
  {
    willf = new will.Willfile( o.willf ).preform();
    r.willf = willf;
    r.new = false;
  }

  return r;
}

willfileFor.defaults =
{
  willf : null,
  combining : false,
}

//

function willfileUnregister( willf )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  // _.assert( will.willfileWithCommonPathMap[ willf.commonPath ] === willf );
  // delete will.willfileWithCommonPathMap[ willf.commonPath ];
  // _.assert( _.arrayCountElement( _.mapVals( will.willfileWithCommonPathMap ), willf ) === 0 );

  _.arrayRemoveOnceStrictly( will.willfileWithCommonPathMap[ willf.commonPath ], willf );
  if( !will.willfileWithCommonPathMap[ willf.commonPath ].length )
  delete will.willfileWithCommonPathMap[ willf.commonPath ];

  let filePath = _.arrayAs( willf.filePath );
  for( let f = 0 ; f < filePath.length ; f++ )
  {
    _.assert( will.willfileWithFilePathPathMap[ filePath[ f ] ] === willf );
    delete will.willfileWithFilePathPathMap[ filePath[ f ] ];
  }
  _.assert( _.arrayCountElement( _.mapVals( will.willfileWithFilePathPathMap ), willf ) === 0 );

  _.arrayRemoveOnceStrictly( will.willfilesArray, willf );

}

//

function willfileRegister( willf )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.arrayAppendOnceStrictly( will.willfilesArray, willf );

  let filePath = _.arrayAs( willf.filePath );
  for( let f = 0 ; f < filePath.length ; f++ )
  {
    _.assert( _.arrayHas( [ willf, undefined ], will.willfileWithFilePathPathMap[ filePath[ f ] ] ) );
    will.willfileWithFilePathPathMap[ filePath[ f ] ] = willf;
  }
  _.assert( _.arrayCountElement( _.mapVals( will.willfileWithFilePathPathMap ), willf ) === filePath.length );

  will.willfileWithCommonPathMap[ willf.commonPath ] = will.willfileWithCommonPathMap[ willf.commonPath ] || [];
  _.arrayAppendOnceStrictly( will.willfileWithCommonPathMap[ willf.commonPath ], willf );
  // _.assert( will.willfileWithCommonPathMap[ willf.commonPath ] === undefined );
  // will.willfileWithCommonPathMap[ willf.commonPath ] = willf;
  // _.assert( _.arrayCountElement( _.mapVals( will.willfileWithCommonPathMap ), willf ) === 1 );

}

// --
// relations
// --

let ResourceKindToClassName = new _.NameMapper({ leftName : 'resource kind', rightName : 'resource class name' }).set
({

  'submodule' : 'Submodule',
  'step' : 'Step',
  'path' : 'PathResource',
  'reflector' : 'Reflector',
  'build' : 'Build',
  'about' : 'About',
  'execution' : 'Execution',
  'exported' : 'Exported',

});

let ResourceKindToMapName = new _.NameMapper({ leftName : 'resource kind', rightName : 'resource map name' }).set
({

  'about' : 'about',
  'module' : 'moduleWithNameMap',
  'submodule' : 'submoduleMap',
  'step' : 'stepMap',
  'path' : 'pathResourceMap',
  'reflector' : 'reflectorMap',
  'build' : 'buildMap',
  'exported' : 'exportedMap',

});

let ResourceKinds = [ 'submodule', 'step', 'path', 'reflector', 'build', 'about', 'execution', 'exported' ];

let Defaults =
{

  attachedWillfilesFormedOfMain : null,
  peerModulesFormedOfMain : null,
  subModulesFormedOfMain : null,
  resourcesFormedOfMain : null,
  allOfMain : null,

  attachedWillfilesFormedOfSub : null,
  peerModulesFormedOfSub : null,
  subModulesFormedOfSub : null,
  resourcesFormedOfSub : null,
  allOfSub : null,

  verbosity : null,
  // recursiveExport : null,

}

let Composes =
{
  verbosity : 3,
  verboseStaging : 0,
  // recursiveExport : 0,
}

let Aggregates =
{

  attachedWillfilesFormedOfMain : null,
  peerModulesFormedOfMain : null,
  subModulesFormedOfMain : null,
  resourcesFormedOfMain : null,
  allOfMain : null,

  attachedWillfilesFormedOfSub : true,
  peerModulesFormedOfSub : true,
  subModulesFormedOfSub : null,
  resourcesFormedOfSub : null,
  allOfSub : null,

}

let Associates =
{

  fileProvider : null,
  filesGraph : null,
  logger : null,

  modulesArray : _.define.own([]),
  moduleWithIdMap : _.define.own({}),
  moduleWithCommonPathMap : _.define.own({}),
  moduleWithNameMap : _.define.own({}),
  mainOpener : null,

  openersArray : _.define.own([]),
  openerModuleWithIdMap : _.define.own({}),
  openersErrorsArray : _.define.own([]),

  willfilesArray : _.define.own([]),
  willfileWithCommonPathMap : _.define.own({}),
  willfileWithFilePathPathMap : _.define.own({}),

}

let Restricts =
{

  formed : 0,
  graphGroup : null,
  willfilesReadBeginTime : null,
  willfilesReadEndTime : null,

}

let Statics =
{

  ResourceCounter : 0,
  ResourceKindToClassName,
  ResourceKindToMapName,
  ResourceKinds,
  Defaults,

}

let Forbids =
{
  mainModule : 'mainModule',
  recursiveExport : 'recursiveExport',
}

// --
// declare
// --

let Extend =
{

  // inter

  finit,
  init,
  unform,
  form,
  formAssociates,

  // etc

  _verbosityChange,
  vcsFor,
  resourcesInfoExport,

  // defaults

  instanceDefaultsApply,
  instanceDefaultsSupplement,
  instanceDefaultsExtend,
  instanceDefaultsReset,
  prefer,

  // module

  moduleEachAt,
  moduleWithAt,
  moduleAt,

  moduleIdUnregister,
  moduleIdRegister,
  modulePathUnregister,
  modulePathRegister,

  modulesGraphInvalidate,
  modulesGraphGroupObtain,
  modulesTopologicalSort,
  modulesInfoExportAsTree,

  // opener

  openerMake,
  openersAdoptModule,
  openerUnregister,
  openerRegister,
  openersErrorsRemoveOf,
  openersErrorsRemoveAll,

  // willfile

  readingBegin,
  readingEnd,

  _willfilesReadBegin,
  _willfilesReadEnd,
  _willfilesReadLog,

  willfilesList,
  willfileWithCommon,
  _willfileWithFilePath,
  willfileWithFilePath,
  willfileFor,
  willfileUnregister,
  willfileRegister,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
wTools[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
require( './IncludeMid.s' );

})();
