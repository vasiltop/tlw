#import "Basic";
#import "Window_Creation";
#import "System";
#import "String";
#import "Math";

Input :: #import "Input";
Simp :: #import "Simp";

window_width := 640;
window_height := 480;
window: Window_Type;

main :: () {
	
	window = create_window(window_width, window_height, "Game");
	window_width, window_height = Simp.get_render_dimensions(window);

	Simp.set_render_target(window, .LEFT_HANDED);

	context.allocator = temp;
	path := path_strip_filename(get_path_of_running_executable());
	set_working_directory(join(path, "../assets"));

	quit := false;
	while !quit {
		Input.update_window_events();

		for Input.get_window_resizes() {
			Simp.update_window(it.window);

			if it.window == window {
				window_width = it.width;
				window_height = it.height;
			}
		}

		for Input.events_this_frame {
			if it.type == .QUIT then quit = true;

			if it.type == {
				case .KEYBOARD;
				if it.key_pressed && it.key_code == .ESCAPE {
					quit = true;
				}
			}
		}

		draw_one_frame();
		sleep_milliseconds(10);
		reset_temporary_storage();
	}
}

draw_one_frame :: () {
	Simp.clear_render_target(.15, .08, .08, 1);
	Simp.set_shader_for_color();
	time := seconds_since_init();

	{
		b := cast(float)window_height / 10;
		p: Vector2;
		p.x = cast(float)(window_width  / 2);
		p.y = cast(float)(window_height / 2);

		theta := cast(float) fmod_cycling(time, TAU);

		ct := cos(theta);
		st := sin(theta);

		w := Vector2.{b*ct, b*st};
		h := Vector2.{b*st, -b*ct};

		p0 := p - w - h;
		p1 := p + w - h;
		p2 := p + w + h;
		p3 := p - w + h;

		a :: 1.0;
		c0 := Vector4.{1, 0, 0, a};
		c1 := Vector4.{0, 1, 0, a};
		c2 := Vector4.{0, 0, 1, a};
		c3 := Vector4.{1, 1, 1, a};

		Simp.immediate_quad(p0, p1, p2, p3, c0, c1, c2, c3);
	}
	
	Simp.swap_buffers(window);
}
