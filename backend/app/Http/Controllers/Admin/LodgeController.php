<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Modules\Lodges\Models\Lodge;
use Illuminate\View\View;

class LodgeController extends Controller
{
    public function index(): View
    {
        $lodges = Lodge::orderBy('name')->paginate(15);

        return view('admin.lodges.index', compact('lodges'));
    }
}
