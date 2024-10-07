from rest_framework import serializers


class GeminiResponseSerializer(serializers.Serializer):
    input = serializers.CharField()
    output = serializers.CharField()
    timestamp = serializers.DateTimeField()
    processing_time = serializers.FloatField()
