// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import AvatarPreviewController from "./avatar_preview_controller"
application.register("avatar-preview", AvatarPreviewController)

import ThumbnailPreviewController from "./thumbnail_preview_controller"
application.register("thumbnail-preview", ThumbnailPreviewController)

import ImageDisplayController from "./image_display_controller"
application.register("image-display", ImageDisplayController)

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)
