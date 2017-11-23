let koa = require('koa'),
    app = new koa(),
    Router = require('koa-router'),
    router = new Router(),
    send = require('koa-send'),
    serve = require('koa-static'),
    fs = require('fs');

const envVars = {
  indexTemplate: '/app/ng/index.html',
  staticFolder: './app'
}

/*
* REST API
* Note: this topic will be provided in CI Pipeline for Angular (3)
*/
router.get('/ng-api/hello', async function(ctx) {
  const resp = {resp: 'world'};
  ctx.body = resp;
  console.log('return user information');
});

// use routes
app.use(router.routes())
  .use(router.allowedMethods());
// \API

// serve static files
app.use(serve(envVars.staticFolder));

// handle rest of requests; in other words, to serve index.html
app.use(async function (ctx) {
  await send(ctx, envVars.indexTemplate);
});

// out errors
app.outputErrors = true;

// set listener
app.listen(8081, () => {
  console.log("listening on 8081");
});
