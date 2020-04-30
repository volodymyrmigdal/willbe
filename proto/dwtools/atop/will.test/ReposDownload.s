
let _ = require( '../../../dwtools/Tools.s' );
_.include( 'wAppBasic' );
_.include( 'wFiles' );

let = assetsOriginalSuitePath = _.path.join( __dirname, '_asset' );
let repoDirPath = _.path.join( assetsOriginalSuitePath, '_repo' );
let ready = new _.Consequence().take( null );
let start = _.process.starter
({
  currentPath : repoDirPath,
  outputCollecting : 1,
  ready : ready,
})

module.exports = reposRedownload;

//

function reposRedownload()
{

  ready.then( () =>
  {
    // _.fileProvider.filesDelete( repoDirPath );
    _.fileProvider.dirMake( repoDirPath );
    return null;
  });

  // clone( 'Color', '4ac65b56d4ca59d6e8ec48d3d70f410fae930ed3' ); */
  // clone( 'PathBasic', '622fb3c259013f3f6e2aeec73642645b3ce81dbc' );
  // clone( 'Procedure', 'd7b2cd8dc0a82a78343100462fe399c92cabe55c' );
  // clone( 'Proto', '70fcc0c31996758b86f85aea1ae58e0e8c2cb8a7' );
  // clone( 'Tools', '8fa27d72fe02d5e496b26e16669970a69d71fdb1' );
  // clone( 'UriBasic', 'd7022e6dcd5ab7f2d71aeb740d41a65dfaabdecf' );

  // clone( 'ModuleForTesting1', 'ea9c4c13030724406dc9896171a9d4e12d3bfedf' ); // Tools
  // clone( 'ModuleForTesting1a', '3ab5bd8bf672538571f2378e11be7f47e6e58414' ); // Color
  // clone( 'ModuleForTesting1b', 'a6a8a6e4fa650c034e8a0ae2cc85a74f3031a01a' );
  // clone( 'ModuleForTesting2', '6d2a274c756af06121fefdd41f756bf2635943d3' ); // PathBasic
  // clone( 'ModuleForTesting2a', '5bd7ebfbe9e95f37de3468013087d87eb0bc1f3d' );
  // clone( 'ModuleForTesting2b', '60e5b51fbb0853fd2f3b90b15fe6c93ae1d82745' ); // UriBasic
  // clone( 'ModuleForTesting12', 'be2c704e5cb4ee2b80a067b6ee9bf3217e72b770' ); // Proto
  // clone( 'ModuleForTesting12ab', 'e5e33c19dbbdbcbc7605a4fd542d39de3b011645' ); // Procedure

  clone( 'ModuleForTesting1', '954607ae477fcdd18f941a23e059f88948677039' ); // Tools
  clone( 'ModuleForTesting1a', '3ba07ca2872edee43a73fd89274b29aa3513d321' ); // Color
  clone( 'ModuleForTesting1b', 'ce766c7a8950e3d3d3bf61b321938c2c759bc210' );
  clone( 'ModuleForTesting2', '7cc7659b6a50f0a1b1c56aded91a719fe8336246' );
  clone( 'ModuleForTesting2a', 'aed847d09f8d22370d47e7aed9ad7f9efd67de1d' ); // PathBasic
  clone( 'ModuleForTesting2b', '556243ac16a715dac88723d351b32097ffc0f138' ); // Procedure
  clone( 'ModuleForTesting12', '6a72704899b76019d9bb37e5582a1b5721e32167' ); // Proto
  clone( 'ModuleForTesting12ab', 'bbb9ad721d667e435203aeda409e83a0b1ad3844' ); // UriBasic

  return ready;
}

//

function clone( name, version )
{

  if( !_.fileProvider.isDir( _.path.join( repoDirPath, name ) ) )
  start( 'git clone https://github.com/Wandalen/w' + name + '.git ' + name );
  start({ execPath : 'git checkout ' + version, currentPath : _.path.join( repoDirPath, name ) });

}
