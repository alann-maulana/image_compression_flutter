#include "include/image_compression_flutter/image_compression_flutter_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define IMAGE_COMPRESSION_FLUTTER_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), image_compression_flutter_plugin_get_type(), \
                              ImageCompressionFlutterPlugin))

struct _ImageCompressionFlutterPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(ImageCompressionFlutterPlugin, image_compression_flutter_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void image_compression_flutter_plugin_handle_method_call(
    ImageCompressionFlutterPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  fl_method_call_respond(method_call, response, nullptr);
}

static void image_compression_flutter_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(image_compression_flutter_plugin_parent_class)->dispose(object);
}

static void image_compression_flutter_plugin_class_init(ImageCompressionFlutterPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = image_compression_flutter_plugin_dispose;
}

static void image_compression_flutter_plugin_init(ImageCompressionFlutterPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  ImageCompressionFlutterPlugin* plugin = IMAGE_COMPRESSION_FLUTTER_PLUGIN(user_data);
  image_compression_flutter_plugin_handle_method_call(plugin, method_call);
}

void image_compression_flutter_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  ImageCompressionFlutterPlugin* plugin = IMAGE_COMPRESSION_FLUTTER_PLUGIN(
      g_object_new(image_compression_flutter_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "image_compression_flutter",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
