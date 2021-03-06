﻿package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	
	TweenPlugin.activate([ColorMatrixFilterPlugin]);
	
	public class Main extends MovieClip {
		
		private var timer:Timer;
		private var puntaje_txt:TextField;
		private var vidas_txt:TextField;
		
		private var puntos:int;
		private var vidas:int;
		private var inicio:MovieClip;
		
		public function Main() {
			
			inicio=new home();
			inicio.y=-inicio.height;
			TweenLite.to(inicio,0.5,{y:0});
			addChild(inicio);
			inicio.btnJugar.addEventListener(MouseEvent.CLICK,levantarHome);
			inicio.btnJugar.buttonMode=true;
		}
		
		private function levantarHome(e:MouseEvent){
			TweenLite.to(inicio,0.5,{y:-800,onComplete:jugar});
		}
		
		private function crearTimer():void{
			timer = new Timer(1500);
			timer.addEventListener(TimerEvent.TIMER, crearMonstruos);
			timer.start();
		}
		
		private function crearCarteles():void{
			vidas = 10;
			puntaje_txt = new TextField;
			puntaje_txt.opaqueBackground = true;
			puntaje_txt.defaultTextFormat = new TextFormat("Arial", 16);
			puntaje_txt.text = "Puntaje: 0";
			puntaje_txt.textColor = 0xFFFFFF;
			puntaje_txt.height = puntaje_txt.textHeight * 1.5;			
			vidas_txt = new TextField;
			vidas_txt.opaqueBackground = true;
			vidas_txt.defaultTextFormat = new TextFormat("Arial", 16);
			vidas_txt.text = "Vidas: "+vidas;
			vidas_txt.textColor = 0xFFFFFF;
			vidas_txt.height = puntaje_txt.textHeight * 1.5;
			vidas_txt.x = stage.stageWidth - vidas_txt.width;
			puntos = 0;
			addChild(puntaje_txt);
			addChild(vidas_txt);
		}
		
		private function jugar():void{
			removeChild(inicio);
			var fondo:Sound=new Sound();
			fondo.load(new URLRequest("sounds/hell-Mike_Koenig-144950046.mp3"));
			var fondoChannel:SoundChannel=fondo.play();
			crearTimer();
			crearCarteles();
			stage.addEventListener(Event.ENTER_FRAME, mover);
		}
		
		private function mover(e:Event):void{
			var hijos:int = numChildren;
			if(hijos > 0){
				for(var i:int = 0; i < hijos; i++){
					var mc:MovieClip = getChildAt(i) as MovieClip;
					if(mc){
						mc.x += 5;
						
						if(mc.x >= stage.stageWidth){
							vidas--;
							//TweenLite.to(mc, 1, {colorMatrixFilter:{colorize:0xff0000, amount:0.5}});
							TweenLite.to(this, 0.5, {onComplete:regresarEstadoNormal,
										 			colorMatrixFilter:{colorize:0x000000, amount:0.5}});
							vidas_txt.text = "Vidas: " + vidas.toString();
							removeChild(mc);
							
							hijos--
							
							if(vidas == 0){
								trace("Acabó");
								stage.removeEventListener(Event.ENTER_FRAME, mover);
								timer.stop();
							}
							
						}
					}
					
				}
			}
		}
		
		private function regresarEstadoNormal():void{
			TweenLite.to(this, 0.5, {colorMatrixFilter:{colorize:0x000000, amount:0}});
		}
													 
		
		private function crearMonstruos(e:TimerEvent):void{
			var mod:int = timer.currentCount%3;
			
			var enemigo:MovieClip
			if(mod == 0){
				enemigo = new enemigo1();
				enemigo.tabIndex = 4;
				enemigo.name = "enemigo1";
			}
			else{
				enemigo = new enemigo2();
				enemigo.tabIndex = 2;
				enemigo.name = "enemigo2";
			}
			enemigo.scaleX=-1;
			enemigo.x = 0;
			enemigo.y = Math.random()*stage.stageWidth;
			
			enemigo.addEventListener(MouseEvent.CLICK, matar);
			
			addChild(enemigo);
		}
		
		private function matar(e:MouseEvent):void{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var nombre:String = mc.name;
			//trace(mc.tabIndex);
			
			mc.tabIndex--;
			
			if(mc.tabIndex == 0){
				
				//removeChild(mc);
				mc.removeEventListener(MouseEvent.CLICK, matar);
				
				TweenLite.to(mc, 0.5, {alpha:0, onComplete:removeChild, onCompleteParams:[mc]});
				
				puntos++;
				
				puntaje_txt.text = "Puntaje: " + puntos.toString();
				
			}
			else{
				if(nombre == "enemigo1"){
					
					mc.scaleX = -1.5;
					mc.scaleY = 1.5;
					TweenLite.to(mc, 0.3, {x:"+50", scaleX:-1, scaleY:1});
				}
				else{
					mc.scaleX = -1.5;
					mc.scaleY = 1.5;
					TweenLite.to(mc, 0.3, {rotation:"+50", scaleX:-1, scaleY:1 });
				}
				
			}
		}
	}
	
}