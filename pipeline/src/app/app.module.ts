import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { SkeletonComponent } from './skeleton/skeleton.component';
import { TestOneComponent } from './test-one/test-one.component';
import { TestTwoComponent } from './test-two/test-two.component';

@NgModule({
  declarations: [
    AppComponent,
    SkeletonComponent,
    TestOneComponent,
    TestTwoComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
