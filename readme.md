namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class CalixtaWebhookController extends Controller
{
    public function handle(Request $request)
    {
        // 1. Validar que sea un evento de mensaje creado
        if ($request->input('type') !== 'message-created') {
            return response()->json(['message' => 'Evento ignorado'], 200);
        }

        $messageData = $request->input('data.object');
        $now = Carbon::now();

        // 2. Preparar el contenido para los archivos
        $logContent = "[" . $now->toDateTimeString() . "] " . json_encode($request->all(), JSON_UNESCAPED_UNICODE) . PHP_EOL;

        // 3. Guardar en Storage (Laravel crea directorios automáticamente con 'append')
        // Los archivos quedarán en storage/app/Calixta/...
        $dailyFile = "Calixta/daily/" . $now->format('Y-m-d') . ".log";
        $monthlyFile = "Calixta/monthly/" . $now->format('Y-m') . ".log";

        Storage::append($dailyFile, $logContent);
        Storage::append($monthlyFile, $logContent);

        // 4. Guardar en Base de Datos MySQL
        try {
            DB::table('calixta_messages')->insert([
                'uuid'       => $messageData['uuid'],
                'author'     => $messageData['author'],
                'body'       => $messageData['body'],
                'type'       => $messageData['type'],
                'source'     => $messageData['chat']['source'] ?? 'unknown',
                'raw_json'   => json_encode($request->all()),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } catch (\Exception $e) {
            \Log::error("Error Webhook Calixta: " . $e->getMessage());
            // Respondemos 200 para que Calixta no reintente el envío infinitamente
        }

        return response()->json(['status' => 'received'], 200);
    }
}
