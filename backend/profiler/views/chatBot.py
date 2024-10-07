import time
from datetime import datetime
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from backend.profiler.serializations.chatBot import GeminiResponseSerializer


class GeminiAPIView(APIView):
    def post(self, request):
        input_text = request.data.get('input', '')

        start_time = time.time()

        output_text = f"Processed: {input_text}"

        processing_time = time.time() - start_time

        response_data = {
            'input': input_text,
            'output': output_text,
            'timestamp': datetime.now(),
            'processing_time': processing_time,
        }

        serializer = GeminiResponseSerializer(data=response_data)
        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
