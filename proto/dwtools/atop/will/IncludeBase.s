( function _IncludeBase_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wSelector' );
  _.include( 'wResolver' );
  _.include( 'wResolverExtra' );
  _.include( 'wCopyable' );
  _.include( 'wAppBasic' );
  _.include( 'wLogger' );

  _.include( 'wVerbal' );
  _.include( 'wTemplateTreeEnvironment' );
  _.include( 'wStager' );
  _.include( 'wGraphBasic' );
  _.include( 'wGitTools' );
  _.include( 'wNpmTools' );
  _.include( 'wYamlTools' );

  _.include( 'wFiles' );
  _.include( 'wFilesArchive' );
  _.include( 'wFilesEncoders' );

  _.include( 'wStateStorage' );
  _.include( 'wStateSession' );
  _.include( 'wCommandsAggregator' );
  _.include( 'wCommandsConfig' );
  _.include( 'wNameMapper' );
  _.include( 'wTemplateFileWriter' );

}

})();
