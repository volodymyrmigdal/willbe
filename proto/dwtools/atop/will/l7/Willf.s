( function _Willf_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

//

let _ = wTools;
let Crypto;
let Parent = null;
let Self = function wWillfile( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Willfile';

// --
// inter
// --

function finit()
{
  let willf = this;

  if( willf.storageWillfile )
  {
    _.arrayRemoveOnce( willf.storageWillfile.storedWillfiles, willf );
    _.assert( !willf.storageWillfile || willf.storageWillfile === willf || _.arrayCountElement( willf.storageWillfile.storedWillfiles, willf ) === 0 );
    if( willf.storageWillfile && willf.storageWillfile !== willf )
    if( !willf.storageWillfile.isUsed() )
    {
      willf.storageWillfile.finit();
      willf.storageWillfile = null;
    }
  }

  if( willf.storedWillfiles )
  {
    let storedWillfiles = willf.storedWillfiles.slice();
    willf.storedWillfiles.splice( 0, willf.storedWillfiles.length );
    storedWillfiles.forEach( ( storedWillfile ) =>
    {
      _.assert( storedWillfile.storageWillfile === willf );
      storedWillfile.storageWillfile = null;
      if( !storedWillfile.isUsed() )
      storedWillfile.finit();
    });
  }

  if( willf.peerWillfiles )
  {
    let peerWillfiles = willf.peerWillfiles.slice();
    willf.peerWillfiles.splice();
    willf.peerWillfiles = null;
    peerWillfiles.forEach( ( peerWillfile ) =>
    {
      if( peerWillfile.peerWillfiles )
      {
        _.arrayRemoveOnceStrictly( peerWillfile.peerWillfiles, willf );
        if( !peerWillfile.peerWillfiles.length )
        peerWillfile.peerWillfiles = null;
      }
      if( !peerWillfile.isUsed() )
      debugger;
      if( !peerWillfile.isUsed() )
      peerWillfile.finit();
    });
  }

  if( willf.formed )
  willf.unform();

  _.assert( willf.openers.length === 0 );
  _.assert( willf.openedModule === null );
  _.assert( willf.storedWillfiles.length === 0 );

  return _.Copyable.prototype.finit.apply( willf, arguments );
}

//

function init( o )
{
  let willf = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  willf[ moduleStructureSymbol ] = null;
  _.workpiece.initFields( willf );
  Object.preventExtensions( willf );

  _.assert( willf.openers.length === 0 );

  _.Will.ResourceCounter += 1;
  willf.id = _.Will.ResourceCounter;

  if( o )
  willf.copy( o );

  _.assert( !!willf.will );

}

//

function unform()
{
  let willf = this;
  let will = willf.will;
  let openedModule = willf.openedModule;
  let storageWillfile = willf.storageWillfile;

  _.assert( arguments.length === 0 );
  _.assert( !!willf.formed );

  /* begin */

  let openers = willf.openers.slice();
  for( let i = 0 ; i < openers.length ; i++ )
  openers[ i ].willfileUnregister( willf );

  if( openedModule )
  openedModule.willfileUnregister( willf );

  will.willfileUnregister( willf );

  if( willf.storageWillfile )
  _.arrayRemoveOnce( willf.storageWillfile.storedWillfiles, willf );
  _.assert( !willf.storageWillfile || willf.storageWillfile === willf || _.arrayCountElement( willf.storageWillfile.storedWillfiles, willf ) === 0 );

  /* end */

  willf.formed = 0;
  return willf;
}

//

function form()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!will );
  _.assert( !!will.formed );
  _.assert( !!fileProvider );
  _.assert( !!logger );

  if( willf.formed === 5 )
  return true;

  if( willf.formed === 0 )
  willf.preform();

  _.assert( willf.formed === 2 || willf.formed === 3 || willf.formed === 4 );

  willf._read();

  _.assert( willf.formed === 3 )

  willf._open();

  _.assert( willf.formed === 4 )

  willf._importToModule();

  _.assert( willf.formed === 5 );

  return true;
}

//

function preform()
{
  _.assert( !!this.will );
  _.assert( arguments.length === 0 );

  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( willf.formed >= 2 )
  return willf;

  _.assert( willf.formed === 0 );

  willf._registerForm();
  willf._inPathsForm();

  _.assert( willf.formed === 2 );
  return willf;
}

//

function _registerForm()
{
  _.assert( !!this.will );

  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( willf.formed === 0 );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );

  if( willf.formed >= 2 )
  return willf;

  /* begin */

  for( let i = 0 ; i < willf.openers.length ; i++ )
  willf.openers[ i ].willfileRegister( willf );

  if( willf.openedModule )
  willf.openedModule.willfileRegister( willf );

  will.willfileRegister( willf );

  if( willf.storageWillfile )
  _.arrayAppendOnce( willf.storageWillfile.storedWillfiles, willf );
  _.assert( !willf.storageWillfile || willf.storageWillfile === willf || _.arrayCountElement( willf.storageWillfile.storedWillfiles, willf ) === 1 );

  /* end */

  willf.formed = 1;
  return willf;
}

//

function _inPathsForm()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( willf.formed > 1 )
  return;

  _.assert( arguments.length === 0 );
  _.assert( !!will );
  _.assert( !!will.formed );
  _.assert( willf.formed === 1 );

  if( !willf.filePath )
  {
    _.assert( _.strIs( willf.dirPath ) );
    willf.filePath = path.join( willf.dirPath, will.AbstractModule.PrefixPathForRole( willf.role, willf.isOut ) );
  }

  if( _.arrayIs( willf.filePath ) )
  formFor( willf.filePath[ 0 ] );
  else
  formFor( willf.filePath );

  willf.formed = 2;

  /* */

  function formFor( filePath )
  {

    willf.dirPath = path.detrail( path.dir( filePath ) );

    if( willf.isOut === null )
    willf.isOut = _.strHas( filePath, /\.out\.\w+\.\w+$/ );

    if( willf.role === null )
    {
      willf.role = will.AbstractModule.PathToRole( filePath );
      // if( _.strHas( filePath, /\.im\.will(\.|$)/ ) )
      // willf.role = 'import';
      // else if( _.strHas( filePath, /\.ex\.will(\.|$)/ ) )
      // willf.role = 'export';
      // else
      // willf.role = 'single';
    }

    if( willf.storagePath === null )
    willf.storagePath = filePath;

    if( willf.storageWillfile === null )
    willf.storageWillfile = willf;

  }
}

//

function _read()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( willf.formed > 2 )
  return true;

  _.assert( willf.formed === 2 );
  _.assert( arguments.length === 0 );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );

  /* read */

  try
  {

    if( willf.error )
    throw willf.error;

    if( !willf.structure )
    if( !willf.exists() )
    {
      // debugger;
      throw _.errBrief( `Found no willfile at ${willf.filePath}` );
    }

    if( willf.structure )
    {
      _.assert( _.strIs( willf.storagePath ) && willf.storagePath !== willf.filePath );
    }
    else
    {

      _.assert( !!willf._found, `Cant open ${willf.filePath}` );
      _.assert( willf._found.length === 1, `Found ${willf._found.length} files at ${willf.filePath}` );
      _.assert( _.strIs( willf._found[ 0 ].ext ), `Cant open ${willf.filePath}` );

      willf.data = fileProvider.fileRead
      ({
        encoding : 'buffer.bytes',
        filePath : willf.filePath,
        verbosity : 0,
      });

      // willf.data = fileProvider.fileConfigRead
      // ({
      //   filePath : willf.filePath,
      //   // verbosity : will.verbosity-2,
      //   verbosity : 0,
      //   found : willf._found,
      // });

    }

    willf.formed = 3;

    _.assert( _.bufferBytesIs( willf.data ) || willf.data === null, `Something wrong with content of willfile ${willf.filePath}` );
    _.assert( _.bufferBytesIs( willf.data ) || willf.filePath !== willf.storagePath, `Something wrong with content of willfile ${willf.filePath}` );

    _.assert( willf.dirPath === path.detrail( path.dir( _.arrayAs( willf.filePath )[ 0 ] ) ) );

    // if( will.verbosity >= 3 )
    willf._readLog( 1, 0 );

  }
  catch( err )
  {
    err = _.err( err, `\nFailed to read willfile ${willf.filePath}` );
    // err = _.err( _.errBrief( err ), `\nFailed to read willfile ${willf.filePath}` );

    willf.error = willf.error || err;

    if( err )
    willf._readLog( 1, 1 );

    if( will.verbosity >= 5 )
    {
      logger.up( 2 );
      logger.log( _.errOnce( err ) );
      logger.down( 2 );
    }
    throw err;
  }

  /* */

  return true;
}

//

function _open()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let inconsistent = 0;

  if( willf.formed === 2 )
  willf._read();

  if( willf.formed > 3 )
  return true;

  _.assert( willf.formed === 3 );
  _.assert( arguments.length === 0 );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !willf.storageWillfile || willf.storageWillfile === willf || _.arrayCountElement( willf.storageWillfile.storedWillfiles, willf ) === 1 );

  /* read */

  try
  {

    if( willf.error )
    throw willf.error;

    if( !willf.data )
    {
      _.assert( _.strIs( willf.storagePath ) && willf.storagePath !== willf.filePath );
    }
    else
    {

      _.assert( !!willf._found, `Cant open ${willf.filePath}` );
      _.assert( willf._found.length === 1, `Found ${willf._found.length} files at ${willf.filePath}` );
      _.assert( _.strIs( willf._found[ 0 ].ext ), `Cant open ${willf.filePath}` );

/*
      zzz qqq : make it working
      let encoder = _.Gdf.Select
      ({
        in : 'buffer.raw',
        out : 'structure',
        ext : 'yml',
      })[ 0 ];
      let structure = encoder.encode( bufferRaw );
*/

      let encoder = _.Gdf.Select
      ({
        in : 'string',
        out : 'structure',
        ext : willf._found[ 0 ].ext,
      })[ 0 ];
      _.assert( !!encoder, `No encoder for ${willf.filePath}` );
      willf.structure = encoder.encode({ data : _.bufferToStr( willf.data ) }).data;

    }

    willf.formed = 4;

    if( willf.structure.format !== undefined && willf.structure.format !== willf.FormatVersion )
    throw _.errBrief
    (
      `Does not support format ${willf.structure.format}, supports only ${willf.FormatVersion},\nPlease, re-export modules.`
    );

    _.assert( _.mapIs( willf.structure ), `Something wrong with content of willfile ${willf.filePath}` );

    try
    {
      if( willf.structure.format )
      _.sureMapHasOnly( willf.structure, willf.KnownSectionsOfOut, () => 'Out-willfile should not have section(s) :' );
      else
      _.sureMapHasOnly( willf.structure, willf.KnownSectionsOfIn, () => 'Willfile should not have section(s) :' );
    }
    catch( err )
    {
      throw _.errBrief( err );
    }

    willf[ moduleStructureSymbol ] = willf.structure;
    if( willf.structure.format )
    willf[ moduleStructureSymbol ] = willf.structureOf( willf );

    if( !willf.isConsistent() )
    {
      inconsistent = 1;
      let peerWillfilesPath = willf.peerWillfilesPathGet();
      peerWillfilesPath = _.arrayAs( peerWillfilesPath );
      throw _.errBrief
      (
          `Out-willfile is inconsistent with its in-willfiles:`
        + `\n${peerWillfilesPath.join( '\n' )}`
        + `\nProbably it's outdated. Consider reexporting submodules recursively with command "will .recursive.export"`
      );
    }

    // _.assert( willf.dirPath === path.detrail( path.dir( willf.filePath ) ) );

    // if( will.verbosity >= 3 )
    willf._readLog( 0, 0 );

    if( willf.structure.module )
    willf._attachedModulesOpen();

  }
  catch( err )
  {
    err = _.err( err, `\nFailed to open willfile ${willf.filePath}` );
    // err = _.err( _.errBrief( err ), `Failed to open willfile ${willf.filePath}\n` );

    willf.error = willf.error || err;
    willf._readLog( 0, inconsistent ? 2 : 1 );

    if( will.verbosity >= 5 )
    {
      logger.up( 2 );
      logger.log( _.errOnce( err ) );
      logger.down( 2 );
    }
    throw err;
  }

  /* */

  return true;
}

//

function _readLog( reading, failed )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let read;

  let verbosity = 3;
  if( reading )
  verbosity = 5;
  if( will.verbosity < verbosity )
  return;

  let low = reading ? 'read' : 'open';
  let high = reading ? 'Read' : 'Opened';

  if( failed && failed !== 2 )
  read = low;
  else
  read = high;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( willf.storagePath ) );

  let filePath = _.color.strFormat( _.arrayAs( willf.filePath ), 'path' );

  if( willf.storagePath && willf.storagePath !== willf.filePath )
  {
    let storagePath = _.color.strFormat( path.s.relative( _.arrayAs( willf.filePath ), willf.storagePath ), 'path' );
    for( let f = 0 ; f < filePath.length ; f++ )
    {
      if( failed )
      debugger;
      if( failed === 2 )
      logger.log( ` ! Inconsistent . ${filePath[ f ]} from ${storagePath[ f ]}` );
      else if( failed )
      logger.log( ` ! Failed to ${read} . ${filePath[ f ]} from ${storagePath[ f ]}` );
      else
      logger.log( ` . ${read} . ${filePath[ f ]} from ${storagePath[ f ]}` );
    }
  }
  else
  {
    for( let f = 0 ; f < filePath.length ; f++ )
    {
      if( failed )
      debugger;
      if( failed === 2 )
      logger.log( ` ! Inconsistent . ${filePath[ f ]}` );
      else if( failed )
      logger.log( ` ! Failed to ${read} . ${filePath[ f ]}` );
      else
      logger.log( ` . ${read} . ${filePath[ f ]}` );
    }
  }

}

//

function _importToModule()
{
  let willf = this;
  let openedModule = willf.openedModule;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let structure = willf.structure;

  _.assert( willf.formed === 4 );
  _.assert( arguments.length === 0 );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( _.mapIs( structure ) );

  try
  {

    if( willf.error )
    throw willf.error;

    if( structure.format !== undefined && structure.format !== willf.FormatVersion )
    throw _.err
    (
      `Does not support format ${structure.format}, supports only ${willf.FormatVersion},\nPlease, re-export modules.`
    );

    if( willf.structure.format )
    {
      _.sureMapHasOnly( structure, willf.KnownSectionsOfOut, () => 'Out-willfile should not have section(s) :' );
      _.assert
      (
          _.arrayIs( structure.root ) && structure.root.length === 1
        , `Found ${structure.root.length} roots. Implemented only for single root.`
      )
    }
    else
    {
      _.sureMapHasOnly( structure, willf.KnownSectionsOfIn, () => 'Willfile should not have section(s) :' );
    }

    /* */

    let mstructure = willf.structureOf( openedModule );
    if( mstructure.about )
    openedModule.about.copy( mstructure.about );

    let con = _.Consequence().take( null );

    /* */

    willf._resourcesImport( will.Exported, mstructure.exported );
    willf._resourcesImport( will.ModulesRelation, mstructure.submodule );
    willf._resourcesImport( will.PathResource, mstructure.path );
    willf._resourcesImport( will.Step, mstructure.step );
    willf._resourcesImport( will.Reflector, mstructure.reflector );
    willf._resourcesImport( will.Build, mstructure.build );

    _.assert( path.s.allAreAbsolute( openedModule.pathResourceMap[ 'module.dir' ].path ) );
    _.assert( path.s.allAreAbsolute( openedModule.pathResourceMap[ 'module.willfiles' ].path ) );
    _.assert( path.s.allAreAbsolute( openedModule.pathResourceMap[ 'will' ].path ) );

  }
  catch( err )
  {
    // debugger;
    // err = _.err( err, `\nFailed to import willfile ${willf.filePath}` );
    throw _.err( err, `\nFailed to import willfile ${willf.filePath}` );
  }

  willf.formed = 5;
  return true;
}

//

function _resourcesImport_pre( routine, args )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  let o = args[ 0 ]
  if( args.length > 1 )
  o = { resourceClass : args[ 0 ], resources : args[ 1 ] }

  _.routineOptions( routine, o );
  _.assert( _.mapIs( o.resources ) || o.resources === null || o.resources === undefined );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );

  return o;
}

function _resourcesImport_body( o )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let openedModule = willf.openedModule;
  let dirPath = openedModule.dirPath;
  let willfilesPath = openedModule.willfilesPath;

  _.assertRoutineOptions( _resourcesImport, arguments );

  if( !o.resources )
  return;

  _.assert( _.mapIs( o.resources ) );
  _.assert( _.constructorIs( o.resourceClass ) );
  _.assert( arguments.length === 1 );

  _.each( o.resources, ( resource, k ) =>
  {

    o.resourceClass.MakeFor
    ({
      module : openedModule,
      willf : willf,
      resource : resource,
      name : k,
    });

  });

}

_resourcesImport_body.defaults =
{
  resourceClass : null,
  resources : null,
}

let _resourcesImport = _.routineFromPreAndBody( _resourcesImport_pre, _resourcesImport_body );

// --
// peer
// --

function peerWillfilesPathGet()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let r;

  _.assert( _.boolLike( willf.isOut ) );
  _.assert( _.mapIs( willf.structure ) );

  let dirPath = willf.dirPath;
  let inPath = willf.elementGet( 'path', 'in' ) || '.';

  if( willf.isOut )
  {
    let originalPath = willf.elementGet( 'path', 'module.original.willfiles' );
    r = path.s.join( dirPath, inPath, originalPath );
  }
  else
  {
    let name = willf.elementGet( 'about', 'name' ) || '';
    let outPath = willf.elementGet( 'path', 'out' ) || '.';
    r = path.join( dirPath, inPath, outPath, name + '.out.will.yml' );
  }

  return r;
}

//

function peerWillfilesOpen()
{
  let willf = this;
  let will = willf.will;
  let peerWillfiles = willf.peerWillfiles;

  _.assert( arguments.length === 0 );

  if( peerWillfiles )
  return peerWillfiles;

  peerWillfiles = willf.peerWillfiles = [];

  let peerWillfilesPath = willf.peerWillfilesPathGet();
  peerWillfilesPath = _.arrayAs( peerWillfilesPath );
  peerWillfilesPath.forEach( ( peerWillfilePath ) =>
  {
    let got = will.willfileFor({ willf : { filePath : peerWillfilePath }, combining : 'supplement' });
    if( got && got.willf )
    {
      peerWillfiles.push( got.willf );
      _.assert( got.willf.peerWillfiles === null || ( got.willf.peerWillfiles.length === 1 && got.willf.peerWillfiles[ 0 ] === willf ) );
      if( got.willf.peerWillfiles === null )
      got.willf.peerWillfiles = [ willf ];
      _.assert( _.arrayHas( got.willf.peerWillfiles, willf ) );
    }
  });

  return peerWillfiles;
}

// --
// hash
// --

function HashFullFromDescriptor( descriptor )
{
  _.assert( _.strDefined( descriptor.hash ) );
  _.assert( _.numberDefined( descriptor.size ) || _.bigIntIs( descriptor.size ) );
  return descriptor.size + '-' + descriptor.hash;
}

//

function hashDescriptorGet( filePath )
{
  let willf = this;

  filePath = filePath || willf.filePath;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let r = willf.hashDescriptorFor( filePath );
  if( !r )
  {
    _.assert( !!willf.data );
    r = Object.create( null );
    r.hash = willf.hashGet();
    r.size = willf.data.byteLength;
  }

  _.assert( _.strDefined( r.hash ) );
  _.assert( _.numberDefined( r.size ) || _.bigIntIs( r.size ) );

  return r;
}

//

function hashDescriptorOfFile( filePath )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );

  if( filePath instanceof Self )
  filePath = filePath.filePath;

  _.assert( _.strIs( filePath ) );

  if( will.verbosity >= 7 )
  logger.log( ` . Hash ${filePath}` );

  let stat = fileProvider.statRead( filePath );
  if( !stat )
  return null;

  let descriptor = Object.create( null );
  descriptor.hash = fileProvider.hashRead( filePath );
  descriptor.size = stat.size;

  if( _.bigIntIs( descriptor.size ) )
  descriptor.size = Number( descriptor.size );

  return descriptor;
}

//

function hashDescriptorFor( filePath )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  if( filePath instanceof Self )
  filePath = willf.filePath;

  if( willf.storageWillfile && willf.storageWillfile.formed < 4 )
  willf.storageWillfile._open();

  _.assert( arguments.length === 1 );
  _.assert( !!willf.storageWillfile );
  _.assert( willf.storageWillfile.formed >= 4, `Storage willfile ${willf.storageWillfile.filePath} is not formed` );
  _.assert( _.mapIs( willf.storageWillfile.structure ), 'Does not have structure to get hash for a willfile from it' );
  _.assert( _.strIs( filePath ) );

  if( !willf.storageWillfile.structure.consistency )
  return null;

  if( path.isAbsolute( filePath ) )
  filePath = path.relative( willf.storageWillfile.dirPath, filePath );

  let desc = willf.storageWillfile.structure.consistency[ filePath ];

  if( !desc )
  return null;

  return desc;
}

//

function hashGet()
{
  let willf = this;
  let hash;

  if( willf.formed < 3 )
  willf._read()

  _.assert( arguments.length === 0 );

  if( willf.hash )
  return willf.hash;

  if( willf.structure )
  hash = willf.hashFor( willf );

  if( hash )
  {
    willf.hash = hash;
    return willf.hash;
  }

  _.assert( !!willf.data, `Willfile ${willf.filePath} does not have data to hash it` );

  willf.data = _.bufferBytesFrom( willf.data );
  willf.hash = hashFor( willf.data );

  return willf.hash;

  /* zzz : move out, maybe */

  function hashFor( data )
  {
    if( Crypto === undefined )
    Crypto = require( 'crypto' );
    let md5sum = Crypto.createHash( 'md5' );
    md5sum.update( data );
    let result = md5sum.digest( 'hex' );
    return result;
  }

}

//

function hashFullGet()
{
  let willf = this;

  _.assert( arguments.length === 0 );
  _.assert( _.bufferAnyIs( willf.data ) && _.numberIs( willf.data.byteLength ), `Willfile does not have data to get its hash` );

  let descriptor = Object.create( null );
  descriptor.hash = willf.hashGet();
  descriptor.size = willf.data.byteLength;

  return willf.HashFullFromDescriptor( descriptor );
}

//

function hashFor( filePath )
{
  let willf = this;

  _.assert( arguments.length === 1 );

  let desc = willf.hashDescriptorFor( filePath );

  if( !desc )
  return null;

  return desc.hash;
}

//

function hashFullFor( filePath )
{
  let willf = this;

  _.assert( arguments.length === 1 );

  let desc = willf.hashDescriptorFor( filePath );

  if( !desc )
  return null;

  return willf.HashFullFromDescriptor( desc );
}

//

function isConsistentWith( willf2, opening )
{
  let willf = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( willf.isOut );

  if( opening === undefined )
  opening = willf2 instanceof Self && !!willf2.data;

  if( opening )
  {
    _.assert( !willf2.isOut );

    let hash1 = willf.hashFullFor( willf2.filePath );
    let hash2 = willf2.hashFullGet();
    if( !hash2 )
    {
      debugger;
      return false;
    }
    return hash1 === hash2;
  }
  else
  {
    let filePath = willf2;
    if( filePath instanceof Self )
    filePath = filePath.filePath;

    _.assert( _.strIs( filePath ) );

    let descriptor = willf.hashDescriptorOfFile( filePath );
    let hash1 = willf.hashFullFor( filePath );
    let hash2 = willf.HashFullFromDescriptor( descriptor );

    if( !hash1 )
    throw _.err( `${willf.filePath} does not have ${filePath}` );

    return hash1 === hash2;
  }

}

//

function isConsistent( opening )
{
  let willf = this;
  let will = willf.will;
  let logger = will.logger;
  let result;

  _.assert( _.boolLike( willf.isOut ) );
  _.assert( arguments.length === 0 );

  if( !willf.isOut )
  return end( true );

  if( opening || willf.peerWillfiles )
  {
    if( !willf.peerWillfiles )
    willf.peerWillfilesOpen();
    let peerWillfiles = willf.peerWillfiles;

    if( peerWillfiles.length === 0 )
    _.assert( 0, 'not tested' );

    result = peerWillfiles.every( ( peerWillfile ) =>
    {
      return willf.isConsistentWith( peerWillfile );
    });
  }
  else
  {

    let peerWillfilesPath = willf.peerWillfilesPathGet();
    peerWillfilesPath = _.arrayAs( peerWillfilesPath );
    result = peerWillfilesPath.every( ( peerWillfilePath ) =>
    {
      return willf.isConsistentWith( peerWillfilePath, 0 );
    });

  }

  return end( result );

  function end( r )
  {
    r = !!r;
    willf._isConsistent = r;
    return r;
  }
}

// --
// etc
// --

function _attachedModulesOpen()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let structure = willf.structure;

  _.assert( _.mapIs( structure ) );
  _.assert( arguments.length === 0 );
  _.strIs( willf.filePath );

  if( !willf.structure.module )
  return;

  for( let relativePath in willf.structure.module )
  {
    let moduleStructure = willf.structure.module[ relativePath ];
    let absolutePath = path.join( willf.dirPath, relativePath );
    if( absolutePath === willf.commonPath )
    continue;

    let inPath = willf.elementFromStructureGet( moduleStructure, 'path', 'in' ) || '.';
    let willfilesPath = willf.elementFromStructureGet( moduleStructure, 'path', 'module.willfiles' );
    willfilesPath = path.s.join( willf.dirPath, path.dirFirst( relativePath ), inPath, willfilesPath );

    let willfOptions =
    {
      filePath : willfilesPath,
      structure : moduleStructure,
      storagePath : willf.filePath,
      storageWillfile : willf,
    }
    let got = will.willfileFor({ willf : willfOptions, combining : 'supplement' });
  }

}

//

function structureOf( object )
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 1 );
  _.assert( object instanceof _.Will.AbstractModule || object instanceof _.Will.Willfile );

  let commonPath = object.commonPath;

  if( !willf.isOut )
  return willf.structure;

  if( !willf.structure.format )
  return willf.structure;

  let relativePath = path.relative( willf.dirPath, commonPath );

  _.sure( _.mapIs( willf.structure.module ), `Structure of willfile ${willf.filePath} does not have section "module"` );
  if( !willf.structure.module[ relativePath ] )
  debugger;

  return willf.structure.module[ relativePath ];
}

//

function commonPathGet()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let willfilesPath = willf.filePath ? willf.filePath : willf.dirPath;

  let common = _.Will.AbstractModule.CommonPathFor( willfilesPath );

  return common;
}

//

function exists()
{
  let willf = this;
  let will = willf.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( willf.formed >= 2 );

  if( !willf._found )
  {

    willf._found = fileProvider.fileConfigFind({ filePath : willf.filePath });
    _.assert( willf._found.length === 0 || willf._found.length === 1 );
    if( willf._found.length )
    {
      willf.filePath = willf._found[ 0 ].particularPath;
    }

  }

  return !!willf._found && !!willf._found.length;
}

//

function isUsed()
{
  let willf = this;

  _.assert( arguments.length === 0 );
  _.assert( !willf.finitedIs() );

  if( willf.openers.length !== 0 )
  return true;

  if( willf.openedModule !== null )
  return true;


  if( willf.storedWillfiles.length )
  {
    if( willf.storedWillfiles.some( ( willf2 ) => willf2.isUsed() ) )
    return true;
  }

  return false;
}

//

function dataSet( src )
{
  let willf = this;

  _.assert( src === null || _.strIs( src ) || _.bufferRawIs( src ) || _.bufferBytesIs( src ) );

  if( willf.data === src )
  return src;

  willf[ dataSymbol ] = src;
  willf.hash = null;

  return src;
}

//

function structureSet( src )
{
  let willf = this;

  _.assert( src === null || _.mapIs( src ) );

  if( willf.structure === src )
  return src;

  willf[ structureSymbol ] = src;
  willf.hash = null;

  return src;
}

//

function moduleStructureGet( src )
{
  let willf = this;
  return willf[ moduleStructureSymbol ];
}

//

function elementGet( sectionName, elementName )
{
  let willf = this;
  let will = willf.will;
  let willfs = will.willfileWithCommonPathMap[ willf.commonPath ];
  let result;

  _.assert( arguments.length === 2 );
  _.assert( _.arrayHas( willfs, willf ) );

  for( let w = 0 ; w < willfs.length ; w++ )
  {
    let willf2 = willfs[ w ];
    let moduleStructure = willf2.structureOf( willf2 );

    let result2 = willf.elementFromStructureGet( moduleStructure, sectionName, elementName );

    if( result2 === undefined )
    continue;

    _.assert
    (
      result === undefined || result === result2,
      () => `${sectionName}::${elementName} is redefined in ${willf2.filePath}`
    );

    result = result2;
  }

  return result;
}

//

function elementFromStructureGet( structure, sectionName, elementName )
{
  let willf = this;
  let will = willf.will;

  _.assert( arguments.length === 3 );
  _.assert( _.mapIs( structure ) );

  if( !structure[ sectionName ] )
  return;
  if( !structure[ sectionName ][ elementName ] )
  return;

  let result = structure[ sectionName ][ elementName ];

  if( sectionName === 'path' || sectionName === 'submodule' )
  if( _.mapIs( result ) )
  result = result.path;

  return result;
}

//

function errorSet( err )
{
  let willf = this;
  let will = willf.will;

  if( willf.error === err )
  return;

  willf[ errorSymbol ] = err;

  return err;
}

// --
// relations
// --

let dataSymbol = Symbol.for( 'data' );
let structureSymbol = Symbol.for( 'structure' );
let moduleStructureSymbol = Symbol.for( 'moduleStructure' );
let errorSymbol = Symbol.for( 'error' );

let KnownSectionsOfIn =
{

  about : null,
  submodule : null,
  path : null,
  reflector : null,
  step : null,
  build : null,
  exported : null,
  consistency : null,

}

let KnownSectionsOfOut =
{

  format : null,
  root : null,
  module : null,
  consistency : null,

}

let Composes =
{
  role : null,
  isOut : null,
  storagePath : null,
  filePath : null,
  dirPath : null,
}

let Aggregates =
{
}

let Associates =
{
  data : null,
  structure : null,
  hash : null,
  will : null,
  openedModule : null,
  openers : _.define.own([]),
  storageWillfile : null,
}

let Medials =
{
}

let Restricts =
{
  error : null,
  formed : 0,
  id : 0,
  _found : null,
  _isConsistent : null,
  peerWillfiles : null,
  storedWillfiles : _.define.own([]),
}

let Statics =
{
  KnownSectionsOfIn,
  KnownSectionsOfOut,
  FormatVersion : 'outwillfile-2.0',
  HashFullFromDescriptor,
}

let Forbids =
{
  module : 'module',
  submoduleMap : 'submoduleMap',
  pathMap : 'pathMap',
  pathResourceMap : 'pathResourceMap',
  reflectorMap : 'reflectorMap',
  stepMap : 'stepMap',
  buildMap : 'buildMap',
  exportedMap : 'exportedMap',
  openerModule : 'openerModule',
  storageModule : 'storageModule',
  isOutFile : 'isOutFile',
  KnownSections : 'KnownSections',
}

let Accessors =
{

  commonPath : { readOnly : 1 },
  data : {},
  structure : {},
  moduleStructure : { readOnly : 1 },
  error : { setter : errorSet },

}

// --
// declare
// --

let Extend =
{

  // inter

  finit,
  init,

  // former

  unform,
  form,

  preform,
  _registerForm,
  _inPathsForm,
  _read,
  _open,
  _readLog,
  _importToModule,
  _resourcesImport,

  // peer

  peerWillfilesPathGet,
  peerWillfilesOpen,

  // hash

  HashFullFromDescriptor,
  hashDescriptorGet,
  hashDescriptorOfFile,
  hashDescriptorFor,
  hashGet,
  hashFullGet,
  hashFor,
  hashFullFor,
  isConsistentWith,
  isConsistent,

  // etc

  _attachedModulesOpen,

  structureOf,
  commonPathGet,
  exists,
  isUsed,
  dataSet,
  structureSet,
  moduleStructureGet,
  elementGet,
  elementFromStructureGet,
  errorSet,

  // relation

  Composes,
  Aggregates,
  Associates,
  Medials,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

_.staticDeclare
({
  prototype : _.Will.prototype,
  name : Self.shortName,
  value : Self,
});

})();
