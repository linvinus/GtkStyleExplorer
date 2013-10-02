/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * author: Konstantinov Denis linvinus@gmail.com
 * 
 */

using Gtk;
using Cairo;
using Posix;

const string UI_FILE = "window2.ui";
const string UI_PREVIEW = "previewframe.ui";

public class point_a {
	public unowned Gtk.ActionGroup ag;
	public StringBuilder sb;
	public point_a(Gtk.ActionGroup ag) {
		this.ag=ag;
		this.sb=new StringBuilder();
	}
}

public delegate void MyCallBack(Gtk.Action a);

public class TimerObject: GLib.Object{
	private Gtk.Window win;
	private Gtk.Widget w;
	private uint timet = 0;
	public TimerObject(Gtk.Window win,Gtk.Widget w){
		/*self destroying object*/
		this.win=win;
		this.w=w;
		this.win.get_style_context().add_class("test_window");
		this.w.get_style_context().add_class("test");
		Gtk.StyleContext.reset_widgets(win.get_screen ());//force apply new class
//~ 		if(w is Gtk.Label|| w is Gtk.CellView){
//~ 			this.w.parent.get_style_context().add_class("test");
//~ 		}
		this.timet=GLib.Timeout.add_seconds(2,this.on_timeout);
		this.ref();
	}
	public bool on_timeout(){
		if(this.timet!=0){
			this.timet=0;
		}
		this.win.get_style_context().remove_class("test_window");
		this.w.get_style_context().remove_class("test");
		Gtk.StyleContext.reset_widgets(win.get_screen ());//force remove new class
//~ 		if(w is Gtk.Label || w is Gtk.CellView){
//~ 			this.w.parent.get_style_context().remove_class("test");
//~ 		}
		this.unref();//destroy
		return false;//stop timer		
	}
}


public class TWFMainWindow : Window{
	//public Gtk.Builder builder;
	public Gtk.Builder preview;
	
	public Gtk.ActionGroup action_group;
	public Gtk.AccelGroup  accel_group;
	public Gtk.Settings xsettings;
	
	[CCode (instance_pos = -1)]
	public void on_button2_clicked (Button source) {
		source.label = "Thanks!";
		this.title=source.label;
	}
	
	[CCode (instance_pos = -1)]
	public bool on_scale_value_changed (Widget w,ScrollType scroll, double new_value) {
		
 		var progressbar1 = (Gtk.ProgressBar)this.preview.get_object("progressbar1");
			progressbar1.set_fraction(new_value/100.0);
 		    progressbar1 = (Gtk.ProgressBar)this.preview.get_object("progressbar2");
			progressbar1.set_fraction((100.0-new_value)/100.0);
 		    progressbar1 = (Gtk.ProgressBar)this.preview.get_object("progressbar3");
			progressbar1.set_fraction(new_value/100.0);
 		    progressbar1 = (Gtk.ProgressBar)this.preview.get_object("progressbar4");
			progressbar1.set_fraction((100.0-new_value)/100.0);

 		var scale = (Gtk.VScale)this.preview.get_object("vscale1");
			scale.set_value(new_value);
 		    scale = (Gtk.VScale)this.preview.get_object("vscale2");
			scale.set_value(new_value);
 		var hscale = (Gtk.HScale)this.preview.get_object("hscale1");
			hscale.set_value(new_value);
 		    hscale = (Gtk.HScale)this.preview.get_object("hscale2");
			hscale.set_value(new_value);

			
 		this.title="on_scale_value_changed =%f".printf(new_value);
 		return false;
	}

	
	construct {
//~ 		this.builder = new Gtk.Builder();
//~ 		this.builder.add_from_file(UI_FILE);
//~ 		this.builder.connect_signals(this);

		this.preview = new Gtk.Builder();
		this.preview.add_from_file(UI_PREVIEW);
		this.preview.connect_signals(this);
		this.add((Gtk.Widget)this.preview.get_object("preview-frame"));

		var vscale1 = (Gtk.Range)this.preview.get_object("vscale1");
		if(vscale1!=null){
			vscale1.set_range(0.0,100.0);
			vscale1.set_increments(1.0,1.0);
			vscale1.set_value(50.0);
		}
		vscale1 = (Gtk.Range)this.preview.get_object("vscale2");
		if(vscale1!=null){
			vscale1.set_range(0.0,100.0);
			vscale1.set_increments(1.0,1.0);
			vscale1.set_value(50.0);
		}
		vscale1 = (Gtk.Range)this.preview.get_object("hscale1");
		if(vscale1!=null){
			vscale1.set_range(0.0,100.0);
			vscale1.set_increments(1.0,1.0);
			vscale1.set_value(50.0);
		}
		vscale1 = (Gtk.Range)this.preview.get_object("hscale2");
		if(vscale1!=null){
			vscale1.set_range(0.0,100.0);
			vscale1.set_increments(1.0,1.0);
			vscale1.set_value(50.0);
		}
		
		this.show_all();
		this.destroy.connect (()=>{Gtk.main_quit();});
		this.setup_keyboard_accelerators();	
		
		this.xsettings = Gtk.Settings.get_default();

		var reset_css = new CssProvider ();
		string reset_css_style = """
			
			.test,
			.test *,
			.test:active ,
			.test:active *,
			.test:insensitive,
			.test:insensitive *,
			.test:focus,
			.test:focus *,
			.test:hover,
			.test:hover *,
			.test:selected,
			.test:selected *,
			.test:selected:active,
			.test:selected:active *
			 {
				background-color: #FF0000;
				background-image: none;
				border-style: solid;
				border-color: #0000FF;	
				/*border-width: 2px;	
				padding: 2px;
				margin: 2px;*/
				box-shadow:none;
				/*background-clip: content-box;*/
				background-clip: border-box;
				/*background-origin: none;
				background-size: none;*/
				background-repeat: no-repeat;
				color: #00FF00;
				transition-property: none;
				transition-duration: 0;				
			}
			.test_window,
			.test_window:active,
			.test_window:insensitive,
			.test_window:focus,
			.test_window:hover,
			.test_window:selected,
			.test_window:selected:active
			 {
				background-color: #FFFF00;
				background-image: none;
				border-style: solid;
				border-color: #00FFFF;	
				box-shadow:none;
			}			
		""";
		try{
			reset_css.load_from_data (reset_css_style,-1);
			Gtk.StyleContext.add_provider_for_screen(this.get_screen(),reset_css,Gtk.STYLE_PROVIDER_PRIORITY_USER);
		}catch (Error e) {
			printf("Theme error! loading default..");
		}		
	}
	
	private bool check_for_existing_action(string name,string default_accel){
		unowned Gtk.Action action = this.action_group.get_action(name);
		unowned uint accelerator_key;
		unowned Gdk.ModifierType accelerator_mods;
		unowned AccelKey* ak;

		if(action!=null){
			Gtk.accelerator_parse(default_accel,out accelerator_key,out accelerator_mods);
			ak=this.accel_group.find((key, closure) =>{	return (closure==action.get_accel_closure()); });
			//if current accel don't equal to parsed, then try to update
			if(ak->accel_key!=accelerator_key || ak->accel_mods!=accelerator_mods){
				//debug("accel error: %s key:%d mod:%d",action.get_accel_path(),(int)accelerator_key,(int)accelerator_mods);
				//update accelerator for action if parsed corrected
				if(accelerator_key!=0 && accelerator_mods!=0){
					//debug("update accel: %",action.get_accel_path());
					AccelMap am=Gtk.AccelMap.get();
					am.change_entry(action.get_accel_path(),accelerator_key,accelerator_mods,false);
				}
			}
			//just update config to be enshure that settings are same as we think
			var parsed_name=Gtk.accelerator_name (ak->accel_key, ak->accel_mods);
			//conf.set_accel_string(name,parsed_name);
			return true;
		}
		return false;
	}	
	
	private void add_window_accel(string name,string? label, string? tooltip, string? stock_id,string default_accel, MyCallBack cb){
		if(!check_for_existing_action(name,default_accel))
			this.add_window_accel_real(new Gtk.Action(name, label, tooltip, stock_id),default_accel,cb);
	}

	private void add_window_toggle_accel(string name,string? label, string? tooltip, string? stock_id,string default_accel, MyCallBack cb){
		if(!check_for_existing_action(name,default_accel))
			this.add_window_accel_real(new Gtk.ToggleAction(name, label, tooltip, stock_id),default_accel,cb);
	}

	private void add_window_accel_real(Gtk.Action action, string accel, MyCallBack cb){

		//we can't connect cb dirrectly to action.activate
		//so, using lambda again =(
		action.activate.connect(()=>{cb(action);});
		//add in to action_group to make a single repository
		this.action_group.add_action_with_accel (action,accel);
		action.set_accel_group (this.accel_group);//use main window accel group
		action.connect_accelerator ();
		//inc refcount otherwise action will be freed at the end of this function
		//action.ref();
	}
	
	public void setup_keyboard_accelerators() {


		if(this.accel_group==null){
			this.accel_group = new Gtk.AccelGroup();
			this.add_accel_group (accel_group);
		}
		
		if(this.action_group==null)
			this.action_group = new Gtk.ActionGroup("TWFVALA");
	

		/* Add New Tab on <Ctrl><Shift>t */
		this.add_window_accel("reload", _("Reload"), _("Reload"), Gtk.Stock.NEW,"F9",()=>{
			this.reload();
			//this.hide_window();
		});
		this.add_window_accel("default", _("Reload"), _("Reload"), Gtk.Stock.NEW,"F1",()=>{
			this.xsettings.gtk_theme_name="Gnome";
			//this.reload();
			//this.hide_window();
		});
		this.add_window_accel("rested", _("Reload"), _("Reload"), Gtk.Stock.NEW,"F2",()=>{
			this.xsettings.gtk_theme_name="Greybird";
			//this.reload();
			//this.hide_window();
		});
		this.add_window_accel("clear", _("Reload"), _("Reload"), Gtk.Stock.NEW,"F3",()=>{
			var reset_css = new CssProvider ();
			string reset_css_style = """
				* {
					engine: none;
					padding:0;
					margin:0;
					border-width: 0px;
					border-radius: 0;
					border-style: none;
					color: inherit;
					background-color: inherit;
					box-shadow: none;
				}
			""";
			try{
				reset_css.load_from_data (reset_css_style,-1);
				Gtk.StyleContext.add_provider_for_screen(this.get_screen(),reset_css,Gtk.STYLE_PROVIDER_PRIORITY_USER);
			}catch (Error e) {
				printf("Theme error! loading default..");
			}
		});
		
		//grave.on_trigged.connect(this.hide_window);
	}//setup_keyboard_accelerators
	
	private void hide_window(){
		this.hide();
		GLib.Timeout.add(5000,show_window);
	}
	private bool show_window(){
		this.show();
		return false;
	}

	private void update_events(){
		var window = this.get_window();
			//window.process_updates(true);//force update
			window.enable_synchronized_configure();//force update
		while (Gtk.events_pending ()){
			Gtk.main_iteration ();
			}
		Gdk.flush();

	}

	public void print_settings(){
		
		//xsettings.gtk_theme_name="Greybird";
		//xsettings.gtk_cursor_theme_name="xcursor-transparent-theme";
				
//~ 		printf("color_hash=%s\n",xsettings.color_hash);
		printf("gtk_alternative_button_order=%d\n",(int)xsettings.gtk_alternative_button_order);
		printf("gtk_alternative_sort_arrows=%d\n",(int)xsettings.gtk_alternative_sort_arrows);
		printf("gtk_application_prefer_dark_theme=%d\n",(int)xsettings.gtk_application_prefer_dark_theme);
		printf("gtk_auto_mnemonics=%d\n",(int)xsettings.gtk_auto_mnemonics);
		printf("gtk_button_images=%d\n",(int)xsettings.gtk_button_images);
		printf("gtk_can_change_accels=%d\n",(int)xsettings.gtk_can_change_accels);
		printf("gtk_color_palette=%s\n",xsettings.gtk_color_palette);
		printf("gtk_color_scheme=%s\n",xsettings.gtk_color_scheme);
		printf("gtk_cursor_blink=%d\n",(int)xsettings.gtk_cursor_blink);
		printf("gtk_cursor_blink_time=%d\n",(int)xsettings.gtk_cursor_blink_time);
		printf("gtk_cursor_blink_timeout=%d\n",(int)xsettings.gtk_cursor_blink_timeout);
		printf("gtk_cursor_theme_name=%s\n",xsettings.gtk_cursor_theme_name);
		printf("gtk_cursor_theme_size=%d\n",(int)xsettings.gtk_cursor_theme_size);
		printf("gtk_dnd_drag_threshold=%d\n",(int)xsettings.gtk_dnd_drag_threshold);
		printf("gtk_double_click_distance=%d\n",(int)xsettings.gtk_double_click_distance);
		printf("gtk_double_click_time=%d\n",(int)xsettings.gtk_double_click_time);
		printf("gtk_enable_accels=%d\n",(int)xsettings.gtk_enable_accels);
		printf("gtk_enable_animations=%d\n",(int)xsettings.gtk_enable_animations);
		printf("gtk_enable_event_sounds=%d\n",(int)xsettings.gtk_enable_event_sounds);
		printf("gtk_enable_input_feedback_sounds=%d\n",(int)xsettings.gtk_enable_input_feedback_sounds);
		printf("gtk_enable_mnemonics=%d\n",(int)xsettings.gtk_enable_mnemonics);
		printf("gtk_enable_primary_paste=%d\n",(int)xsettings.gtk_enable_primary_paste);
		printf("gtk_enable_tooltips=%d\n",(int)xsettings.gtk_enable_tooltips);
		printf("gtk_entry_password_hint_timeout=%d\n",(int)xsettings.gtk_entry_password_hint_timeout);
		printf("gtk_entry_select_on_focus=%d\n",(int)xsettings.gtk_entry_select_on_focus);
		printf("gtk_error_bell=%d\n",(int)xsettings.gtk_error_bell);
		printf("gtk_fallback_icon_theme=%s\n",xsettings.gtk_fallback_icon_theme);
		printf("gtk_file_chooser_backend=%s\n",xsettings.gtk_file_chooser_backend);
		printf("gtk_font_name=%s\n",xsettings.gtk_font_name);
		printf("gtk_fontconfig_timestamp=%d\n",(int)xsettings.gtk_fontconfig_timestamp);
		printf("gtk_icon_sizes=%s\n",xsettings.gtk_icon_sizes);
		printf("gtk_icon_theme_name=%s\n",xsettings.gtk_icon_theme_name);
		printf("gtk_im_module=%s\n",xsettings.gtk_im_module);
		printf("gtk_im_preedit_style=%d\n",(int)xsettings.gtk_im_preedit_style);
		printf("gtk_im_status_style=%d\n",(int)xsettings.gtk_im_status_style);
		printf("gtk_key_theme_name=%s\n",xsettings.gtk_key_theme_name);
		printf("gtk_keynav_cursor_only=%d\n",(int)xsettings.gtk_keynav_cursor_only);
		printf("gtk_keynav_wrap_around=%d\n",(int)xsettings.gtk_keynav_wrap_around);
		printf("gtk_label_select_on_focus=%d\n",(int)xsettings.gtk_label_select_on_focus);
		printf("gtk_menu_bar_accel=%s\n",xsettings.gtk_menu_bar_accel);
		printf("gtk_menu_bar_popup_delay=%d\n",(int)xsettings.gtk_menu_bar_popup_delay);
		printf("gtk_menu_images=%d\n",(int)xsettings.gtk_menu_images);
		printf("gtk_menu_popdown_delay=%d\n",(int)xsettings.gtk_menu_popdown_delay);
		printf("gtk_menu_popup_delay=%d\n",(int)xsettings.gtk_menu_popup_delay);
		printf("gtk_modules=%s\n",xsettings.gtk_modules);
		printf("gtk_print_backends=%s\n",xsettings.gtk_print_backends);
		printf("gtk_print_preview_command=%s\n",xsettings.gtk_print_preview_command);
		printf("gtk_recent_files_limit=%d\n",(int)xsettings.gtk_recent_files_limit);
		printf("gtk_recent_files_max_age=%d\n",(int)xsettings.gtk_recent_files_max_age);
		printf("gtk_scrolled_window_placement=%d\n",(int)xsettings.gtk_scrolled_window_placement);
		printf("gtk_shell_shows_app_menu=%d\n",(int)xsettings.gtk_shell_shows_app_menu);
		printf("gtk_shell_shows_menubar=%d\n",(int)xsettings.gtk_shell_shows_menubar);
		printf("gtk_show_input_method_menu=%d\n",(int)xsettings.gtk_show_input_method_menu);
		printf("gtk_show_unicode_menu=%d\n",(int)xsettings.gtk_show_unicode_menu);
		printf("gtk_sound_theme_name=%s\n",xsettings.gtk_sound_theme_name);
		printf("gtk_split_cursor=%d\n",(int)xsettings.gtk_split_cursor);
		printf("gtk_theme_name=%s\n",xsettings.gtk_theme_name);
		printf("gtk_timeout_expand=%d\n",(int)xsettings.gtk_timeout_expand);
		printf("gtk_timeout_initial=%d\n",(int)xsettings.gtk_timeout_initial);
		printf("gtk_timeout_repeat=%d\n",(int)xsettings.gtk_timeout_repeat);
		printf("gtk_toolbar_icon_size=%d\n",(int)xsettings.gtk_toolbar_icon_size);
		printf("gtk_toolbar_style=%d\n",(int)xsettings.gtk_toolbar_style);
		printf("gtk_tooltip_browse_mode_timeout=%d\n",(int)xsettings.gtk_tooltip_browse_mode_timeout);
		printf("gtk_tooltip_browse_timeout=%d\n",(int)xsettings.gtk_tooltip_browse_timeout);
		printf("gtk_tooltip_timeout=%d\n",(int)xsettings.gtk_tooltip_timeout);
		printf("gtk_touchscreen_mode=%d\n",(int)xsettings.gtk_touchscreen_mode);
		printf("gtk_visible_focus=%d\n",(int)xsettings.gtk_visible_focus);
		printf("gtk_xft_antialias=%d\n",(int)xsettings.gtk_xft_antialias);
		printf("gtk_xft_dpi=%d\n",(int)xsettings.gtk_xft_dpi);
		printf("gtk_xft_hinting=%d\n",(int)xsettings.gtk_xft_hinting);
		printf("gtk_xft_hintstyle=%d\n",(int)xsettings.gtk_xft_hintstyle);
		printf("gtk_xft_rgba=%s\n",xsettings.gtk_xft_rgba);		
	}	
	
	public Gtk.Widget get_useful_widget(Gtk.Widget p){
		if(p is Gtk.Alignment || p is Gtk.Fixed || p is Gtk.Viewport || p is Gtk.DrawingArea || p is Gtk.CellView){
			return get_useful_widget(p.parent);
		}
		return p;
	}
	
	public string? check_obj(X.Event event,GLib.Object obj,ref Gtk.Widget? obj_return){
		int x, y ,h, w;
		string? ret=null;
			if(obj is Gtk.Widget){
				Gtk.Widget W = (Gtk.Widget)obj;
				if(!W.get_realized()) return null; //skip hidden widgets
				//widget x,y
				if(W.get_toplevel()!=this.get_toplevel()) return null;
				W.translate_coordinates(this, 0, 0, out x, out y);
				h=W.get_allocated_height();
				w=W.get_allocated_width();
				
				if( event.xbutton.x>=x && event.xbutton.y>=y &&
				   (event.xbutton.x<=(x+w) && event.xbutton.y <=(y+h) /*&& (W is Gtk.Alignment)==false*/)  ){

					uint path_length;
					string path;
					string path_reversed;

					W.class_path (out path_length, out path, out path_reversed);
					ret=path;
					obj_return=W;
					
					//printf("Found! x=%d y =%d w=%d h=%d %s %s \n",x, y, w, h, W.name,path);
					if( W is Gtk.Bin && ((Gtk.Bin) W).get_child() != null){
						//printf("Gtk.Bin.get_child() != null ");
						var tmp=this.check_obj(event,((Gtk.Bin) W).get_child(),ref obj_return);
						if(tmp!=null) ret = tmp;
					}else
					if( (W is Gtk.Container || W is Gtk.Alignment) && ((Gtk.Container) W).get_children() != null){
						//printf("childrens=%d",(int)((Gtk.Container) W).get_children().length());
						foreach(Gtk.Widget children in ((Gtk.Container) W).get_children()){
							var tmp=this.check_obj(event,children,ref obj_return);
							if(tmp!=null) ret = tmp;
						}
						//printf("Gtk.Container.get_children() != null ");
					}
					/*else{
						return ret;
						//printf("Found! x=%d\ty=%d\tw=%d\th=%d\t%s %s %d p=%d\n",x, y, w, h, W.name,path,(int)W,(int)W.parent);
//~ 						if(W is Gtk.Label) {
//~ 							printf("Label=%s\n",((Gtk.Label)W).label);
//~ 							((Gtk.Label)W).label=path;
//~ 						}
					}*/

				}
			}
		return ret;
	}
	
	public void reload(){
		CssProvider provider;
		int x, y ,h, w;
		

		X.Display display = new X.Display();
		X.Event event = X.Event();
		X.Window window = display.default_root_window();

		display.query_pointer(window, out window,
		out event.xbutton.subwindow, out event.xbutton.x_root,
		out event.xbutton.y_root, out event.xbutton.x,
		out event.xbutton.y, out event.xbutton.state);	
		
		this.get_window().get_origin(out x, out y);
		event.xbutton.x-=x;
		event.xbutton.y-=y;
		printf("mouse: x=%d y=%d\n\n",event.xbutton.x,event.xbutton.y);
		string[] paths=null;
		foreach (GLib.Object obj in this.preview.get_objects()) {
 			//var context = ((Gtk.Widget)(obj)).get_style_context ();
 			Gtk.Widget obj_return=null;
			var tmp=this.check_obj(event,obj,ref obj_return);
			if(tmp!=null){
				bool flag=false;
				foreach(string f in paths){
					if(f==tmp){
						flag=true;
						break;
						}
				}
				
				if(!flag){
					paths+=tmp;
					var ww=get_useful_widget(obj_return);
					unowned List<string> list=ww.get_style_context().list_classes();
					printf("found class");
					foreach(string cls in list){
						printf(" .%s",cls);
					}
					printf("\n");
//~ 					int top=-1, left=-1, bottom=-1, right=-1,test=-1;
//~ 					ww.get_style_context().get(ww.get_state_flags(),
//~ 						 "border-top-width", &top,
//~                          "border-left-width", &left,
//~                          "border-bottom-width", &bottom,
//~                          "border-right-width", &right,
//~                          "padding-top", &top,
//~                          "padding-left", &left,
//~                          "padding-bottom", &bottom,
//~                          "padding-right", &right,
//~                          "margin-top", &top,
//~                          "margin-left", &left,
//~                          "margin-bottom", &bottom,
//~                          "margin-right", &right,                         
//~                          null);
//~                     printf("border-top:%dpx border-left:%dpx border-bottom:%dpx border-right:%dpx test:%dpx\n",top, left, bottom, right,test);


//~ 					va_list? list2=null;
//~ 					ww.get_style_context().get(0,list2);
//~ 					foreach(var entry in list2){
//~ 						printf ("%s => %d\n", entry.key, entry.value);
//~ 					}
//~ 					ww.get_style_context().get_style_valist((void*)pvlist);
//~ 					va_list? list2=*((va_list()*)pvlist);
//~ 					//if(list2!=null)
//~ 					for (string? str = list2.arg<string?> (); str != null ; str = list2.arg<string?> ()) {
//~ 						printf("???? %s",str);
//~ 					}
					var t = new TimerObject(this,ww);
					printf("found %s\n",tmp);
				}
			}
		}
			//var context = this.get_style_context ();
			return;
			
			string theme;
			theme = GLib.Environment.get_home_dir() +xsettings.gtk_theme_name+"/gtk-3.0/gtk.css";
			if(!GLib.FileUtils.test(theme,GLib.FileTest.EXISTS) ){
				theme = "/usr/share/themes/" +xsettings.gtk_theme_name+"/gtk-3.0/gtk.css";
				if(!GLib.FileUtils.test(theme,GLib.FileTest.EXISTS) ){
					printf("Theme error! file '%s' not found!",theme);
					return;//theme not found!
				}
			}
			
			
			provider = new CssProvider();
			provider.load_from_path(theme);
			//get_named("Clearlooks-flat-compact", null);
			Gtk.StyleContext.add_provider_for_screen(this.get_screen(),(Gtk.StyleProvider)provider,Gtk.STYLE_PROVIDER_PRIORITY_USER);
			//Gtk.StyleContext.reset_widgets(this.get_screen());
		//	}
	}
	
}//public class TWFMainWindow


int main (string[] args) {
	Gtk.init (ref args);
	var win = new TWFMainWindow ();
	//win.xsettings.gtk_theme_name="Gnome";
	win.print_settings();
	win.show();
	var dialog = new MessageDialog (null, (DialogFlags.DESTROY_WITH_PARENT | DialogFlags.MODAL), MessageType.QUESTION, ButtonsType.OK, "Move mouse on any widget and press F9\nResult will be on stdout");
	dialog.response.connect ((response_id) => {
		dialog.destroy ();
	});
	//dialog.set_transient_for(this);
	dialog.show ();	
	dialog.run();
	Gtk.main ();
	return 0;
}
