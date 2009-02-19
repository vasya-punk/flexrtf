package controls.rtf.plugins.image
{
	import controls.rtf.RtfCommands;
	import controls.rtf.plugins.BaseManager;
	import controls.rtf.plugins.tree.FileTree;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Image;
	import mx.controls.ProgressBar;
	import mx.controls.TextInput;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import org.w3.dom.html.HTMLImageElement;
	
	public class ImageManagerBase extends BaseManager
	{
		public const DEFAULT_IMAGE_MANAGER_URL:String = "http://localhost/flex/";
		public const DEFAULT_IMAGE_MANAGER_TREE_PARAM:String = "?GetTree";
		public const DEFAULT_IMAGE_MANAGER_REMOVE_PARAM:String = "?RemovePath=";
		public const DEFAULT_IMAGE_MANAGER_UPLOAD_PARAM:String = "?FilePath=";
		public const DEFAULT_IMAGE_MANAGER_UPLOAD_FIELD:String = "FileName";
		
		public var btnBrowse:Button;
		public var btnUpload:Button;
		public var btnInsert:Button;
		public var btnRemove:Button;
		
		public var fileTree:FileTree;
		public var imgPreview:Image;
		public var cmbAlign:ComboBox;
		
		public var filter:FileFilter = new FileFilter("Images (*.png, *.jpg, *.gif)", "*.png;*.jpg;*.gif");
		
		[Bindable] public var txtFile:TextInput;
		public var txtWidth:TextInput;
		public var txtHeight:TextInput;
		public var txtAlt:TextInput;
		public var txtActualWidth:TextInput;
		public var txtActualHeight:TextInput;
		public var txtFileSize:TextInput;
		public var txtContentType:TextInput;
		
		private var file:FileReference = new FileReference();
		public var progressBar:ProgressBar = new ProgressBar();
		
		public function ImageManagerBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private var _url:String = "";
		
		public function get url():String
		{
			if(_url)
				return _url;
					
			_url = getJsProperty("IMAGE_MANAGER_URL");
			 
			return _url || DEFAULT_IMAGE_MANAGER_URL;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get fileTreeUrl():String
		{
			return url + (getJsProperty("IMAGE_MANAGER_TREE_PARAM") || DEFAULT_IMAGE_MANAGER_TREE_PARAM);
		}
		
		public function get removeUrl():String
		{
			return url + (getJsProperty("IMAGE_MANAGER_REMOVE_PARAM") || DEFAULT_IMAGE_MANAGER_REMOVE_PARAM);
		}
		
		public function get uploadUrl():String
		{
			return url + (getJsProperty("IMAGE_MANAGER_UPLOAD_PARAM") || DEFAULT_IMAGE_MANAGER_UPLOAD_PARAM);
		}
		
		public function get uploadFieldName():String
		{
			return getJsProperty("IMAGE_MANAGER_UPLOAD_FIELD") || DEFAULT_IMAGE_MANAGER_UPLOAD_FIELD;
		}
		
		private function getJsProperty(key:String):String
		{
			var value:String = "";
			if(ExternalInterface.available)
				value = String(ExternalInterface.call("function(key){return window[key]||''}",key));
				
			return value;
		}
		
		protected function onTreeChangeHandler(event:ListEvent):void
		{
			var source:String = "";
			var node:XML = fileTree.selectedItem as XML;
			
			if(node)
			{
				if(fileTree.selectedItem is XML)
					source = fileTree.selectedItem.@url;
				
				if(imgPreview && source)
				{
					cursorManager.setBusyCursor();
					imgPreview.source = source;
				}
				
				if(btnInsert)
					btnInsert.enabled = !isBranch(node);
			} 
		}
		
		private function isBranch(node:XML):Boolean
		{
			return (node.@isBranch && node.@isBranch=="true");
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			fileTree.url = fileTreeUrl;
		
			if(btnBrowse)
				btnBrowse.addEventListener(MouseEvent.CLICK, onBrowseClick);
				
			if(fileTree)
				fileTree.addEventListener(ListEvent.CHANGE, onTreeChangeHandler);
				
			if(btnInsert)
				btnInsert.addEventListener(MouseEvent.CLICK, onInsertClick);
				
			if(btnUpload)
				btnUpload.addEventListener(MouseEvent.CLICK, onUploadClickHandler);
				
			if(btnRemove)
				btnRemove.addEventListener(MouseEvent.CLICK, onRemoveClickHandler);
				
			if(imgPreview)
				imgPreview.addEventListener(Event.COMPLETE, onImageComplete);
				
			file.addEventListener(Event.SELECT, onFileSelect);
			file.addEventListener(ProgressEvent.PROGRESS, onFileProgress);
			file.addEventListener(Event.COMPLETE, onFileComplete);
			
			init();
		}
		
		private function onImageComplete(event:Event):void
		{
			if(imgPreview.content)
			{
				var bitmap:Bitmap = imgPreview.content as Bitmap;
				
				if(txtContentType) txtContentType.text  = bitmap.loaderInfo.contentType; 
				if(txtActualWidth) txtActualWidth.text  = String(bitmap.bitmapData.width);
				if(txtActualHeight)txtActualHeight.text = String(bitmap.bitmapData.height);
				if(txtFileSize)    txtFileSize.text     = String(imgPreview.bytesTotal);
			}
			cursorManager.removeBusyCursor();
		}
		
		private function onRemoveClickHandler(event:MouseEvent):void
		{
			Alert.show(
				resourceManager.getString('messages','rtf.imageManager.confirmation.message').replace("{file}",fileTree.selectedItem.@label),
				resourceManager.getString('messages','rtf.imageManager.confirmation.title'),
				Alert.YES | Alert.NO,
				null,
				function(event:CloseEvent):void
				{
					if(event.detail == Alert.YES)
					{
						if(fileTree.selectedItem is XML)
						{
							var node:XML = fileTree.selectedItem as XML;
							
							var service:HTTPService = new HTTPService;
							service.url = removeUrl + node.@path + (isBranch(node) ? "" : node.@label);
							service.method = "GET";
							service.useProxy = false;
							service.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void
							{
								var parent:XML = node.parent();
								if(parent)
								{
									delete parent.children()[node.childIndex()];
									fileTree.selectedItem = parent;
									imgPreview.source = "";
									btnInsert.enabled = false;
								}
							});
							service.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void
							{
								Alert.show(event.message.toString(), event.fault.name);
							});
							service.send();
						}
					}
				}
			);
		}
		
		private function onUploadClickHandler(event:MouseEvent):void
		{
			imgPreview.visible = false;
			progressBar.visible = true;
			
			var path:String = fileTree.selectedItem ? fileTree.selectedItem.@path : "";
			try
			{
                file.upload(new URLRequest(uploadUrl + path), uploadFieldName);
                file.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
                {
                	file.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
                	Alert.show("upload url: " + uploadUrl + path +"\nError: " + e.text);
                });
            }
            catch (err:Error)
            {
                Alert.show(err.message, err.name);
            }
		}
		
		private function onFileComplete(event:Event):void
		{
			var node:XML = XML(<node isBranch="false" />);
			node.@label    = file.name;
			node.@path     = fileTree.selectedItem.@path;
			node.@url      = url + node.@path + file.name;
			node.@size     = file.size;
			
			var parentNode:XML = (fileTree.selectedItem as XML)
			if(!isBranch(parentNode)) parentNode = parentNode.parent();
			parentNode.appendChild(node);
			
			//Alert.show("onFileComplete: " + node.@url);
			
			//(fileTree.dataProvider as XMLListCollection).refresh();
			expandItem(node);
			fileTree.selectedItem = node;
			imgPreview.source = node.@url;
			
			
			btnInsert.enabled = true;
			
			Alert.show(
				resourceManager.getString('messages','rtf.imageManager.upload.message').replace("{file}",file.name),
				resourceManager.getString('messages','rtf.imageManager.upload.title'));
			
			txtFile.text = "";
			progressBar.visible = false;
			imgPreview.visible = true;
		}
		
		private function onFileProgress(event:Event):void
		{
			progressBar.visible = true;
		}
		
		private function onFileSelect(event:Event):void
		{
			txtFile.text = file.name;
		}
		
		private function onBrowseClick(event:MouseEvent):void
		{
			file.browse([filter]);
		}
		
		private function onInsertClick(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			if(opener)
			{
				opener.editor.iframe.setFocus();
				opener.editor.execCommand(RtfCommands.INSERT_IMAGE, false, imgPreview.source.toString());
				opener.editor.execCommand("setImageProperties", false, {
					align:  cmbAlign.selectedLabel,
					width:  txtWidth.text,
					height: txtHeight.text,
					src:    imgPreview.source.toString(),
					id:     "img_" + new Date().getTime(),
					alt:    txtAlt.text
				});
			}
		}
		
		private function init():void
		{
			if(opener)
			{
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].setImageProperties=function(val){" +
						 	"window[id].focus();" +
							"var i,a,d,e=window[id].getActiveElement('IMG');" +
							"if(!e||e.tagName!='IMG'){" +
								"d=window[id].getDocument();" +
								"a=d.getElementsByTagName('IMG');" +
								"for(i=0;i<a.length;i++){" +
									"if(a[i].getAttribute('src')==val.src&&a[i].id!=val.id){" +
										"e=a[i];break"+ 
									"}" + 
								"}" + 
							"}" +
							"if(e){" + 
								"for(i in val)if(val[i]&&val!='src')e.setAttribute(i,val[i]);" +
							"}"+
						"};" +
					"}"+ 
				"}", opener.editor.iframe.uid);
				
				var image:HTMLImageElement = new HTMLImageElement(ExternalInterface.call("function(id){" +
					"var a,obj=null;" + 
					"if(window[id]){" +
						"a=window[id].getActiveElement();" +
						"if(a&&a.tagName=='IMG')" +
							"obj={" +
								"src:a.getAttribute('src')," +
								"name:a.getAttribute('name')," + 
								"alt:a.getAttribute('alt')," +
								"id:a.getAttribute('id')," + 
								"width:a.getAttribute('width')," + 
								"height:a.getAttribute('height')," + 
								"align:a.getAttribute('align')," + 
								"nodeName:'IMG'," +
								"nodeType:1"+
							"};"+ 
					"}" + 
					"return obj;" + 
				"}", opener.editor.iframe.uid));
				
				
				fileTree.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					if(image && image.nodeName=="IMG")
					{
						txtWidth.text  = image.width;
						txtHeight.text = image.height;
						txtAlt.text    = image.alt;
						
						if(image.align)
							for each(var obj:Object in cmbAlign.dataProvider)
								if(image.align.toLowerCase().indexOf(String(obj.label).toLowerCase()) == 0)
									cmbAlign.selectedItem = obj;
									
						if(image.src)
						{
							if(fileTree.dataProvider is XMLListCollection)
							{
								var root:XML = (fileTree.dataProvider as XMLListCollection)[0];
								var node:XML = getNodeByUrl(root.children(), decodeURIComponent(image.src));
								
								callLater(function():void
								{
									if(node)
									{
										expandItem(node);
										fileTree.selectedItem = node;
									}
									fileTree.dispatchEvent(new ListEvent(ListEvent.CHANGE));
								}); 
							}
						}
					}
				});
				
				opener.editor.storeSelection();
			}
		}
		
		private function getNodeByUrl(list:XMLList, url:String):XML
		{
			for each(var node:XML in list)
			{
				if(decodeURIComponent(node.@url) == url)
					return node;
				
				if(node.children().length() > 0)
				{
					var child:XML = getNodeByUrl(node.children(), url);
					if(child)
						return child;
				}
			}
			return null
		}
		
		private function expandItem(item:XML):void
		{
			if(item)
			{
				var parent:XML = item.parent();
				if(parent)
					expandItem(parent);
					
				fileTree.expandItem(item, true);
			}
		}
	}
}