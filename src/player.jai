Player :: struct {
	using pos: Vector2;
	body_texture: Simp.Texture;
	gun_texture: Simp.Texture;
};

load_texture :: (tex: *Simp.Texture, filename: string) {
	ok := Simp.texture_load_from_file(tex, filename);
	assert(ok);
	GL.glBindTexture(GL.GL_TEXTURE_2D, tex.gl_handle);
	GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_NEAREST);
	GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_NEAREST);
}

init :: (using p: *Player) {
	load_texture(*body_texture, "textures/player.png");
	load_texture(*gun_texture, "textures/gun.png");
}

draw :: (using p: *Player) {
	Simp.set_shader_for_images(*body_texture);
	Simp.immediate_set_2d_projection(WORLD_WIDTH, WORLD_HEIGHT);

	Simp.immediate_begin();
	defer Simp.immediate_flush();

	w := cast(float)body_texture.width;
	h := cast(float)body_texture.height;

	Simp.immediate_quad(.{x, 0}, .{x + w, 0}, .{x + w, h}, .{x, h});
}
